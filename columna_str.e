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
			create column_data.make (0)
		end

feature -- Access
	get_data : ARRAYED_LIST[STRING]
		do Result :=column_data end

feature -- Basic operations
	not_replicate_data
		do
			not_replicates:=true
		end

	add_data (new_data: STRING)
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
	column_data: ARRAYED_LIST[STRING]

end
