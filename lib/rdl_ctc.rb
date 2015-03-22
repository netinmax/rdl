
module RDL
    
    class ContractViolationException < StandardError; end
    
    ##########################
    ### Contract Structure ###
    
    class Contract
        def initialize(desc="No Description", &ctc)
            @pred = ctc
            @str = desc
            @node_bindings = [] # TODO: Add node bindings for CbD-CSP
        end
        def check(*v,prev:"", blame:0)
          if (@pred && ((@pred.arity < 0) ? (@pred.arity.abs - 1) <= v.size : @pred.arity == v.size)) then
              # TODO: Labels and proc.parameters :lbl, :rest
              raise ContractViolationException, "Value(s) #{v.inspect} does not match contract(s) #{self.rdoc_gen}\n    Blaming: #{prev}." unless (@pred.call(*v))
            else
                raise ContractViolationException, "Error: Invalid number of arguments in Contract #{self.rdoc_gen}: Expecting arity #{@pred.arity}, got #{v}"
            end
        end
        def name(desc="Contract<#{self}>")
            @name = desc;
        end
        def get_name()
            @name
        end
        def to_s
            rdoc_gen
        end
        def to_proc
            x = self
            Proc.new { |v| x.check(v,prev:"To_Proc'd #{prev}\n#{rdoc_gen}",blame:0) }
        end
        def descr(str)
            @str = str
            self
        end
        def rdoc_gen
            "Empty Contract"
        end
        def AND(ctc)
            (is_a? AndCtc) ? (add_ctc):(AndCtc.new(self,ctc))
        end
        def OR(ctc)
            (is_a? OrCtc) ? (add_ctc):(OrCtc.new(self,ctc))
        end
    end
    
    ##########################
    ### Contract Labelling ###
    
    # Wrapper for Contracts
    class CtcLabel < Contract
        @ctc = nil
        def initialize(wctc)
            @ctc = wctc
        end
        def check(*v, prev:"", blame:0)
            @ctc.check(*v, prev:"#{prev}\n  #{rdoc_gen}", blame:blame)
        end
        def to_proc
            @ctc.to_proc
        end
        def implies(&ctc)
            @ctc.implies(&ctc)
        end
        alias :old_is_a? :is_a?
        def is_a?(klass)
            RDL.debug "IS_A #{self.to_s}", 8 # TODO label debug channels
            tmp = old_is_a?(klass)
            return (tmp||@ctc.is_a?(klass))
        end
        def rdoc_gen
            "##{self.class} : #{@ctc.rdoc_gen}"
        end
    end
    
    class PreCtc < CtcLabel
    end
    
    class PostCtc < CtcLabel
    end
    
    ############################
    ### Functional Contracts ###
    
    # Contract using user-defined block
    class FlatCtc < Contract
        def rdoc_gen
            "{FlatCtc:#{@str}}"
        end
    end
    
    # Contract that applies pre(left) and post(right) condition
    class MethodCtc < Contract
        attr_accessor :ret, :blk, :has_block_ctc
        def initialize(mname,lctc,rctc)
            @mname = mname
            @lctc = lctc
            @rctc = rctc
            @pred = Proc.new{|env, *v|
                @self = env

                @lctc.check(*v, prev:"PRECONDITION in #{rdoc_gen}", blame:1)
            begin
              RDL.turn_off
              ### ADDED TO CALL BLOCKS #####
              if @has_block_ctc
                @ret = env.send(@mname.to_sym, *v, &@blk)
              else
                @ret = env.send(@mname.to_sym, *v)
                ret2 = nil
                if @ret.class <= Enumerable && @blk != nil
                  ret2 = @ret.send(:each, &@blk)
                end
              end
            ensure
              RDL.turn_on
              ##############################
            end
            
            @rctc.check(*v, @ret, prev:"POSTCONDITION in #{rdoc_gen}", blame:1)
            @ret = ret2 if !ret2.nil?
            ret2 = nil
            next true
            }
        end
        def check(*v, prev:"", blame:0)
            super(*v, prev:prev, blame:blame)
            return @ret
        end
        def add_pre(ctc)
            @lctc = AndCtc.new(@lctc,ctc)
        end
        def add_post(ctc)
            @rctc = AndCtc.new(@rctc,ctc)
        end
        def rdoc_gen
            x = (@lctc.class == Array) ? (@lctc.each {|t| t.rdoc_gen} ).join(',') : @lctc.rdoc_gen
            y = (@rctc.class == Array) ? (@rctc.each {|t| t.rdoc_gen} ).join(',') : @rctc.rdoc_gen
            "CONTRACT for METHOD #{@mname}\n\t(#{x})\n\t-> #{y}"
        end #TODO: RI support, rename rdoc_gen to to_s
    end
    
    class BlockCtc < MethodCtc
        # Initialized with block as first arg instead of mname
        # TODO BlockCtc
        def rdoc_gen
            x = ""
            y = ""
            "Block{|#{x}| -> #{y}}"
        end
    end
    
    ############################
    ### Combinator Contracts ###
    
    # Inner-node structure for contracts capable of holding multiple child contracts
    class OrdNCtc < Contract
        def initialize(*ctcs)
            @ctcls = ctcs
            @emp = false
            @connect = ", "
            init()
        end
        def init; end
        def check(*v, prev:"", blame:0)
            raise ContractViolationException, "Higher Order Contract Failure #{rdoc_gen}\nat #{prev}" unless check_aux(v,0, prev:prev, blame:blame)
        end
        def check_aux(v, nt, prev:"", blame:0)
          ret = (nt >= @ctcls.length) ? @emp : @cond.call(@ctcls[nt], v, nt, prev, blame)
          ret
        end
        def add_ctc(ctc)
            (ctc.is_a? Contract) ? (@ctcls<<ctc) : (raise ContractViolationException, "Attempting to add non-Contract to Contract bundle")
        end
        def rdoc_gen
            rdc="{"
            @ctcls.each {|x| rdc +=x.rdoc_gen; rdc +=@connect;}
            rdc = rdc[0...-@connect.size]
            rdc +="}"
            rdc
        end
    end
    
    # Contract where all child contracts must be held
    class AndCtc < OrdNCtc
        def init
            @emp=true
            @cond = Proc.new{|l, v, nt, prev, blame| 
            l.check(*v, prev:"#{prev}\n  #{rdoc_gen}", blame:blame)
            next check_aux(v, nt+1, prev:prev, blame:blame);
          }
            @connect = " AND "
        end
    end
    
    # Contract where any one child contract must be held
    class OrCtc < OrdNCtc
        def init
            @cond = Proc.new do |l, v, nt, prev, blame|
                begin
                    l.check(*v, prev:"#{prev}\n  #{rdoc_gen}", blame:blame)
                    rescue
                    next check_aux(v, nt+1, prev:prev, blame:blame)
                end
                
                next true
            end
            @connect = " OR "
        end
    end
    
end
