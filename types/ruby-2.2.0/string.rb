class String
  type :new, '(?String str) -> String new_str'
  type :try_convert, '(Object obj) -> String or nil new_string'
  type :%, '(Object) -> String'
  type :*, '(Fixnum) -> String'
  type :+, '(String) -> String'
  type :<<, '(Object) -> String'
  type :<=>, '(String other) -> Fixnum or nil ret'
  type :==, '(%any) -> %bool'
  type :===, '(%any) -> %bool'
#  type :=~, '(Object) -> Fixnum or nil' # TODO: Wrapping this messes up $1 etc
  type :[], '(Fixnum, ?Fixnum) -> String or nil'
  type :[], '(Range or Regexp) -> String or nil'
  type :[], '(Regexp, Fixnum) -> String or nil'
  type :[], '(Regexp, String) -> String or nil'
  type :[], '(String) -> String or nil'
  type :ascii_only?, '() -> %bool'
  type :b, '() -> String'
  type :bytes, '() -> Array' # TODO: bindings to parameterized (vars)
  type :bytesize, '() -> Fixnum'
  type :byteslice, '(Fixnum, ?Fixnum) -> String or nil'
  type :byteslice, '(Range) -> String or nil'
  type :capitalize, '() -> String'
  type :capitalize!, '() -> String or nil'
  type :casecmp, '(String) -> nil or Fixnum'
  type :center, '(Fixnum, ?String) -> String'
  type :chars, '() -> Array'  #deprecated
  type :chomp, '(?String) -> String'
  type :chomp!, '(?String) -> String or nil'
  type :chop, '() -> String'
  type :chop!, '() -> String or nil'
  type :chr, '() -> String'
  type :clear, '() -> String'
  type :codepoints, '() -> Array<Fixnum>' # TODO
  type :codepoints, '() {(?%any) -> %any} -> Array<Fixnum>' # TODO
  type :concat, '(Fixnum or Object) -> String'
  type :count, '(String, *String) -> Fixnum'
  type :crypt, '(String) -> String'
  type :delete, '(String, *String) -> String'
  type :delete!, '(String, *String) -> String or nil'
  type :downcase, '() -> String'
  type :downcase!, '() -> String or nil'
  type :dump, '() -> String'
  type :each_byte, '() {(Fixnum) -> %any} -> String'
  type :each_byte, '() -> Enumerator'
  type :each_char, '() {(String) -> %any} -> String'
  type :each_char, '() -> Enumerator'
  type :each_codepoint, '() {(Fixnum) -> %any} -> String'
  type :each_codepoint, '() -> Enumerator'
  type :each_line, '(?String) {(Fixnum) -> %any} -> String'
  type :each_line, '(?String) -> Enumerator'
  type :empty?, '() -> %bool'
#  type :encode, '(?Encoding, ?Encoding, *Symbol) -> String' # TODO: fix Hash arg
#  type :encode!, '(Encoding, ?Encoding, *Symbol) -> String'
  type :encoding, '() -> Encoding'
  type :end_with?, '(*String) -> %bool'
  type :eql?, '(String) -> %bool'
  type :force_encoding, '(String or Encoding) -> String'
  type :getbyte, '(Fixnum) -> Fixnum or nil'
# Can't wrap these, since they mess with $1 etc
#  type :gsub, '(Regexp or String, String) -> String'
#  type :gsub, '(Regexp or String, Hash) -> String'
#  type :gsub, '(Regexp or String) {(String) -> %any } -> String'
#  type :gsub, '(Regexp or String) ->  Enumerator'
#  type :gsub!, '(Regexp or String, String) -> String or nil'
#  type :gsub!, '(Regexp or String) {(String) -> %any } -> String or nil'
#  type :gsub!, '(Regexp or String) -> Enumerator'
  type :hash, '() -> Fixnum'
  type :hex, '() -> Fixnum'
  type :include?, '(String) -> %bool'
  type :index, '(Regexp or String, ?Fixnum) -> Fixnum or nil'
  type :replace, '(String) -> String'
  type :insert, '(Fixnum, String) -> String'
  type :inspect, '() -> String'
  type :intern, '() -> Symbol'
  type :length, '() -> Fixnum'
  type :lines, '(?String) -> Array<String>'
  type :ljust, '(Fixnum, ?String) -> String' # TODO
  type :lstrip, '() -> String'
  type :lstrip!, '() -> String or nil'
  type :match, '(Regexp or String) -> MatchData'
  type :match, '(Regexp or String, Fixnum) -> MatchData'
  type :next, '() -> String'
  type :next!, '() -> String'
  type :oct, '() -> Fixnum'
  type :ord, '() -> Fixnum'
  type :partition, '(Regexp or String) -> Array<String>'
  type :prepend, '(String) -> String'
  type :reverse, '() -> String'
  type :rindex, '(String or Regexp, ?Fixnum) -> Fixnum or nil' # TODO
  type :rjust, '(Fixnum, ?String) -> String' # TODO
  type :rpartition, '(String or Regexp) -> Array<String>'
  type :rstrip, '() -> String'
  type :rstrip!, '() -> String'
#  type :scan, '(Regexp or String) -> Array<String or Array<String>>' # Can't wrap or screws up last_match
#  type :scan, '(Regexp or String) {(*%any) -> %any} -> Array<String or Array<String>>'
  type :scrub, '(?String) -> String'
  type :scrub, '(?String) {(%any) -> %any} -> String'
  type :scrub!, '(?String) -> String'
  type :scrub!, '(?String) {(%any) -> %any} -> String'
  type :set_byte, '(Fixnum, Fixnum) -> Fixnum'
  type :size, '() -> Fixnum'
  rdl_alias :slice, :[]
  type :slice!, '(Fixnum, ?Fixnum) -> String or nil'
  type :slice!, '(Range or Regexp) -> String or nil'
  type :slice!, '(Regexp, Fixnum) -> String or nil'
  type :slice!, '(Regexp, String) -> String or nil'
  type :slice!, '(String) -> String or nil'
  type :split, '(?(Regexp or String), ?Fixnum) -> Array<String>'
  type :split, '(?Fixnum) -> Array<String>'
  type :squeeze, '(?String) -> String'
  type :squeeze!, '(?String) -> String'
  type :start_with?, '(* String) -> %bool'
  type :strip, '() -> String'
  type :strip!, '() -> String'
# Can't wrap these, since they mess with $1 etc
  # type :sub, '(Regexp or String, String or Hash) -> String'
  # type :sub, '(Regexp or String) {(String) -> %any} -> String'
  # type :sub!, '(Regexp or String, String) -> String' # TODO: Does this really not allow Hash?
  # type :sub!, '(Regexp or String) {(String) -> %any} -> String'
  type :succ, '() -> String'
  type :sum, '(?Fixnum) -> Fixnum'
  type :swapcase, '() -> String'
  type :swapcase!, '() -> String or nil'
  type :to_c, '() -> Complex'
  type :to_f, '() -> Float'
  type :to_i, '(?Fixnum) -> Fixnum'
  type :to_r, '() -> Rational'
  type :to_s, '() -> String'
  type :to_str, '() -> String'
  type :to_sym, '() -> Symbol'
  type :tr, '(String, String) -> String'
  type :tr!, '(String, String) -> String or nil'
  type :tr_s, '(String, String) -> String'
  type :tr_s!, '(String, String) -> String or nil'
  type :unpack, '(String) -> Array<String>'
  type :upcase, '() -> String'
  type :upcase!, '() -> String or nil'
  type :upto, '(String, ?bool) -> Enumerator'
  type :upto, '(String, ?bool) {(String) -> %any } -> String'
  type :valid_encoding?, '() -> %bool'
end
