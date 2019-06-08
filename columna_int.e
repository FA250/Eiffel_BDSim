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

feature -- Basic operations
	not_replicate_data
		do
			not_replicates:=true
		end

	add_data (new_data: INTEGER)
		do
			column_data.force (new_data)
		ensure
			not column_data.is_empty
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
