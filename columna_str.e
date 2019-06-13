note
	description: "Summary description for {COLUMNA_STR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	COLUMNA_STR

inherit
	COLUMNA

create
	make_str

feature {NONE} -- Initialization

	make_str (name: STRING)
			-- Initialization for `Current'.			
		do
			column_name:=name
			type:= "str"
			create column_data.make
		end

feature -- Access
	get_data : LINKED_LIST[STRING]
		do Result :=column_data end

	get_count: INTEGER
		do Result:=column_data.count end


feature -- Basic operations

	get_data_row(index: INTEGER) :STRING
		local
			temp_row:STRING
		do
			temp_row:=column_data.at(index)
			Result :=temp_row
		end

	not_replicate_data
		do
			not_replicates:=true
		end

	add_data (new_data: STRING)
		do
			column_data.extend (new_data)
		end

	verify_data (new_data: STRING):BOOLEAN
		local
			data_ok:BOOLEAN
		do
			if not_replicates then
				from
					column_data.start
					data_ok:=true
				until
					column_data.off
				loop
					if column_data.item.is_equal (new_data) then
						data_ok:=false
					end
					column_data.forth
				end
				Result:=data_ok
			else
				Result:=true
			end
		end

	verify_condition(operator,condition:STRING; contRows:INTEGER):BOOLEAN
		local
			data:STRING
			ok:BOOLEAN
		do
			data:=column_data.at (contRows).to_string_32
			if operator.is_equal ("=")then
					ok:=data.is_equal (condition)
					print("%NBBBB%T"+ok.out+"%N")
					print("%N%T'"+data+"'%N")
					print("%N%T'"+condition+"'%N")
			elseif operator.is_equal ("!=") then
					ok:=not data.is_equal (condition)
			elseif operator.is_equal ("<") then
					ok:=data.is_less (condition)
			elseif operator.is_equal ("<=") then
					ok:=data.is_less_equal (condition)
			elseif operator.is_equal (">=") then
					ok:=data.is_greater_equal (condition)
			elseif operator.is_equal (">") then
					ok:=data.is_greater (condition)
			end

			Result:=ok
		end


feature
	delete_data (index: INTEGER)
		do
			column_data.go_i_th (index)
			column_data.remove()

		end

feature {NONE} -- Implementation
	column_data: LINKED_LIST[STRING]

end
