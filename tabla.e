note
	description: "Summary description for {TABLA}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TABLA

create
	make

feature {NONE} -- Initialization

	make (nombre : STRING)
			-- Initialization for `Current'.
		do
			table_name:=nombre
			id:= ""
			create rows.make(0)
		end


feature -- Access
	get_nom : STRING
		do Result :=table_name end
	get_id : STRING
		do Result :=id end
	get_rows : ARRAYED_LIST[COLUMNA]
		do Result :=rows end


feature -- Basic operations
	add_column (name, type: STRING)
		require
			coherent_type: type.is_equal ("str") or type.is_equal ("int")
		local
			cstr: COLUMNA_STR
			cint: COLUMNA_INT
		do
			if type.is_equal ("str") then
				create cstr.make_str (name)
				rows.force(cstr)
			else
				create cint.make_int (name)
				rows.force(cint)
			end
		ensure
			rows.count/= old rows.count
		end

	not_replicate_data (column_name: STRING)
		require
			not get_rows.is_empty
		do
			from
				rows.start
			until
				rows.off
			loop
				if rows.item.get_nom.is_equal (column_name) then
					rows.item.not_replicate_data
					id:= column_name
				end
				rows.forth
			end
		end

	column_exists (column_name :STRING) : BOOLEAN
		local
			exists: BOOLEAN
		do
			if rows.is_empty then
				Result:=false
			else
				from
					rows.start
					exists:=false
				until
					rows.off
				loop

					if rows.item.get_nom.is_equal (column_name) then
						exists:=true
					end
					rows.forth
				end

				Result:=exists
			end
		end

feature {NONE} --Implementation
	table_name: STRING
	rows: ARRAYED_LIST[COLUMNA]
	id : STRING

invariant
	invariant_clause: True -- Your invariant here

end
