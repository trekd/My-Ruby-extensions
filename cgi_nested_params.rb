class CGI

	def CGI::parse(qs, d = '&;')
		params = {}
		
		(qs || '').split(/[#{d}] */n).each do |p|
			k, v = unescape_uri(p).split('=', 2)
			normalize_params(params, k, v)
		end
		
		return params
	end

	def CGI::normalize_params(params, name, v = nil)
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

	def CGI::unescape_uri(s)
		s.tr('+', ' ').gsub(/((?:%[0-9a-fA-F]{2})+)/n){
			[$1.delete('%')].pack('H*')
		}
	end
	
end
