class CGI
	
	def nested_params()
		@params = parse_nested_query(
                case env_table['REQUEST_METHOD']
                when "GET", "HEAD"
                  if defined?(MOD_RUBY)
                    Apache::request.args or ""
                  else
                    env_table['QUERY_STRING'] or ""
                  end
                when "POST"
                  stdinput.binmode if defined? stdinput.binmode
                  stdinput.read(Integer(env_table['CONTENT_LENGTH'])) or ''
                else
                  read_from_cmdline
                end
              )
	end
	
	def parse_nested_query(qs, d = '&;')
	  params = {}

	  (qs || '').split(/[#{d}] */n).each do |p|
	    k, v = unescape(p).split('=', 2)
	    normalize_params(params, k, v)
	  end

	  return params
	end

	def normalize_params(params, name, v = nil)
	  name =~ %r([\[\]]*([^\[\]]+)\]*)
	  k = $1 || ''
	  after = $' || ''

	  return if k.empty?

	  if after == ""
	    params[k] = v
	  elsif after == "[]"
	    params[k] ||= []
	    raise TypeError unless params[k].is_a?(Array)
	    params[k] << v
	  elsif after =~ %r(^\[\]\[([^\[\]]+)\]$) || after =~ %r(^\[\](.+)$)
	    child_key = $1
	    params[k] ||= []
	    raise TypeError unless params[k].is_a?(Array)
	    if params[k].last.is_a?(Hash) && !params[k].last.key?(child_key)
	      normalize_params(params[k].last, child_key, v)
	    else
	      params[k] << normalize_params({}, child_key, v)
	    end
	  else
	    params[k] ||= {}
	    params[k] = normalize_params(params[k], after, v)
	  end

	  return params
	end

	def unescape(s)
	  s.tr('+', ' ').gsub(/((?:%[0-9a-fA-F]{2})+)/n){
	    [$1.delete('%')].pack('H*')
	  }
	end
	
end