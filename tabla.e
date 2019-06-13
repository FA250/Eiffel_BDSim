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
			create rows.make
		end


feature -- Access
	get_nom : STRING
		do Result :=table_name end
	get_id : STRING
		do Result :=id end
	get_rows : LINKED_LIST[COLUMNA]
		do Result :=rows end
	get_number_rows : INTEGER
		do Result :=rows.count end

feature -- Basic operations
	elim(field,operator,condition:STRING)
		local
			contRows:INTEGER
			column:COLUMNA
			c:COLUMNA
		do
			rows.start
			c:=rows.item

			from
				contRows:=1
			until
				contRows.is_equal (c.get_count+1)
			loop
				if verify_condition(field,operator,condition,contRows) then
					print ("%TFila Eliminada:")
					from
						rows.start
					until
						rows.off
					loop
						print ("%T")
						column:=rows.item
						print(column.get_data_row(contRows))
						column.delete_data (contRows)
						print ("%T")
						rows.forth
					end
					contRows:=contRows-1
					print ("%N")
				end
					contRows:=contRows+1
			end
		end
	verify_condition(field,operator,condition:STRING; contRows:INTEGER):BOOLEAN
		local
			correct:BOOLEAN
			column:COLUMNA
		do
			from
				rows.start
			until
				rows.off
			loop
				column:=rows.item
				if column.get_nom.is_equal (field) then
					correct:=column.verify_condition (operator, condition, controws)
				end
				rows.forth
			end
			Result :=correct
		end

	show_columns_condition(field,operator,condition:STRING)
		local
			contRows:INTEGER
			column:COLUMNA
			c:COLUMNA
		do
			rows.start
			c:=rows.item
			print("%N")
			print_column_names

			from
				contRows:=1
			until
				contRows.is_equal (c.get_count+1)
			loop
				if verify_condition(field,operator,condition,contRows) then
					from
						rows.start
					until
						rows.off
					loop
						print ("%T")
						column:=rows.item
						print(column.get_data_row(contRows))
						print ("%T")
						rows.forth
					end
					print ("%N")
				end
					contRows:=contRows+1
			end
		end



	show_columns
		local
			contRows:INTEGER
			column:COLUMNA
			c:COLUMNA
		do
			rows.start
			c:=rows.item
			print("%N")
			print_column_names
			from
				contRows:=1
			until
				contRows.is_equal (c.get_count+1)
			loop
				from
					rows.start
				until
					rows.off
				loop
					print ("%T")
					column:=rows.item
					print(column.get_data_row(contRows))
					print ("%T")
					rows.forth
				end
				print ("%N")

				contRows:=contRows+1
			end
		end

	print_column_names
		do
			from
				rows.start
			until
				rows.off
			loop
				print ("%T")
				print(rows.item.get_nom)
				print ("%T")
				rows.forth
			end
			print ("%N")
		end

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

	add_row (data_columns : LIST[STRING])
		require
			not data_columns.is_empty
		do
			from
				data_columns.start
				rows.start
			until
				data_columns.off
			loop
				rows.item.add_data (data_columns.item)

				data_columns.forth
				rows.forth
			end
		end

	verify_data(data_columns: LIST[STRING]):BOOLEAN
		require
			not data_columns.is_empty
		local
			data_ok:BOOLEAN
		do
			from
				data_columns.start
				rows.start
				data_ok:=true
			until
				rows.off
			loop
				if not rows.item.verify_data (data_columns.item) then
					data_ok:=false
				end

				data_columns.forth
				rows.forth
			end
			Result:=data_ok

		end

feature {NONE} --Implementation
	table_name: STRING
	rows: LINKED_LIST[COLUMNA]
	id : STRING

invariant
	invariant_clause: True -- Your invariant here

end
