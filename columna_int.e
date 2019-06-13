note
	description: "Summary description for {COLUMNA_INT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	COLUMNA_INT

inherit
	COLUMNA

create
	make_int

feature {NONE} -- Initialization

	make_int (name: STRING)
			-- Initialization for `Current'.			
		do
			column_name:=name
			type:= "int"
			create column_data.make (0)
		end

feature -- Access
	get_data : ARRAYED_LIST[INTEGER]
		do Result :=column_data end

	get_count: INTEGER
		do Result:=column_data.count end

feature -- Basic operations
	get_data_row(index: INTEGER):STRING
		local
			temp_row: INTEGER
		do
			temp_row:=column_data.array_at(index)
			Result:= temp_row.out
		end

	not_replicate_data
		do
			not_replicates:=true
		end

	add_data (new_data: STRING)
		do
			column_data.force (new_data.to_integer)
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
					if column_data.item.is_equal (new_data.to_integer) then
						data_ok:=false
					end
					column_data.forth
				end
				Result:=data_ok
			else
				Result:=true
			end
		end

	delete_data (index: INTEGER)
		require
			data_exits: not get_data.is_empty
		do
			column_data.go_i_th (index)
			column_data.remove
		ensure
			column_data/=old column_data
		end

feature {NONE} -- Implementation
	column_data: ARRAYED_LIST[INTEGER]

end
