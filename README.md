# What is it
It's my personal ruby extension repository


## CGI::nested_params
It's a copy-pasted class from [Rack::Utils](http://rack.rubyforge.org/doc/classes/Rack/Utils.html) and [CGI](http://www.ruby-doc.org/core/classes/CGI.html)

If you have a form like this, ...

	<form action="/cgi-bin/formtest.rb" method="get">
		<table id="attendance">
			<tr class="table-header">
				<th>Name</th>
				<th>Age</th>
			</tr>
			<tr id="row-0">
				<td><input type="text" name="att[0][name]" value="Marianna"></td>
				<td><input type="text" name="att[0][age]" value="45"></td>
			</tr>
			<tr id="row-1">
				<td><input type="text" name="att[1][name]" value="John"></td>
				<td><input type="text" name="att[1][age]" value="12"></td>
			</tr>
		</table>
		<input type="submit" value="Submit">
	</form>

with this extension you can get the **nested parameters** as a **Hash**.

Simply just call the `CGI.nested_params` method after you created the *CGI* object.

	{"att"=>
		{
			"0"=>{"name"=>"name0", "age"=>"12:45"},
			"1"=>{"name"=>"name1", "age"=>"12:45"}
		}
	}