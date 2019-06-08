
deferred class
	COLUMNA

feature -- Access
	get_nom : STRING
		do Result :=column_name end
	get_type : STRING
		do Result :=type end
	get_no_replicate : BOOLEAN
		do Result :=not_replicates end

feature -- Basic operations
	not_replicate_data
		deferred
		ensure
			not_replicates/=old not_replicates
		end

feature {NONE} -- Implementation
	column_name: STRING
	type: STRING
	not_replicates:BOOLEAN
end
