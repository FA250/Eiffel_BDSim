note
	description: "Progra3 application root class"
	date: "$Date$"
	revision: "$Revision$"

class
	APPLICATION

inherit
	ARGUMENTS_32

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			line: STRING
		do
			create tables.make(0)
			create new_table.make ("")
			io.put_string ("Escriba los comandos que necesite")
			io.put_new_line
			io.put_string ("Si ocupa ayuda escriba el comando 'ayuda' en cualquier momento")
			io.put_new_line

			from
				current_command:="none"
				io.put_string ("> ")
				io.read_line
				line := io.last_string
			until
				line.is_equal ("fin")
			loop
				execute_cmd(line)
				io.put_string ("%N> ")
				io.read_line
				line := io.last_string		end

		end

feature -- Access
	get_new_table : TABLA
		do Result :=new_table end

	get_tables : ARRAYED_LIST[TABLA]
		do Result :=tables end

feature -- Commands
	ayuda
		do
			io.put_new_line
			if current_command.is_equal("creartab") then
				io.put_string ("defcol <Nombre columna> <Tipo> %T%T- Crea nueva columna para la tabla que se esta creando")
				io.put_new_line
				io.put_string ("fincreartab %T%T%T%T- Finaliza la creacion de la tabla permitiendo que en todas las columnas se repitan datos")
				io.put_new_line
				io.put_string ("fincreartab <Nombre columna> %T%T- Finaliza la creacion de la tabla y se modifica la columna indicada para que no permita repetir datos")
				io.put_new_line
				io.put_string ("fin %T%T%T%T%T- Finaliza el programa")
				io.put_new_line
			else
				io.put_string ("ayuda %T%T%T%T%T- Muestra los comandos disponibles")
				io.put_new_line
				io.put_string ("creartab <Nombre tabla> %T%T- Crea nueva tabla con el nombre dado")
				io.put_new_line
				io.put_string ("borrartab <Nombre tabla> %T%T- Elimina tabla con el nombre dado y sus datos")
				io.put_new_line
				io.put_string ("ins <Nombre tabla> <Lista valores> %T- Inserta en la tabla especificada la lista de valores dada")
				io.put_new_line
				io.put_string ("elim <Nombre tabla> <Condicion> %T- Elimina los datos que cumplan con la condicion de la tabla indicada")
				io.put_new_line
				io.put_string ("listar <Nombre tabla> %T%T%T- Muestra todos los datos de la tabla")
				io.put_new_line
				io.put_string ("listar <Nombre tabla> <Condicion> %T- Muestra los datos de la tabla que cumplan con la condicion")
				io.put_new_line
				io.put_string ("desc %T%T%T%T%T- Se muestra el nombre de todas las tablas existentes")
				io.put_new_line
				io.put_string ("desc <Nombre tabla> %T%T%T- Muestra la definicion de la tabla y de las columnas")
				io.put_new_line
				io.put_string ("fin %T%T%T%T%T- Finaliza el programa")
				io.put_new_line
			end
		end

	creartab (name: STRING)
		do
			create new_table.make (name)
		ensure
			new_table/=old new_table
		end

	defcol (name, type: STRING)
		require
			correct_type: type.is_equal("str") or type.is_equal("int")
			not get_new_table.column_exists(name)
		do
			new_table.add_column (name, type)
		end

	fincreartab
		do
			tables.force (new_table)
		ensure
			tables.count /= old tables.count
		end

	fincreartabcolumn (column: STRING)
		require
			not column.is_empty
			get_new_table.column_exists(column)
		do
			new_table.not_replicate_data (column)
			tables.force (new_table)
		end

	show_all_tables
		require
			not get_tables.is_empty
		do
			io.put_string ("%N%TTablas: [")
			from
				tables.start
			until
				tables.off
			loop
				io.put_string (tables.item.get_nom)

				if tables.islast then
					io.put_string ("]")
				else
					io.put_string (", ")
				end

				tables.forth
			end
		end

	show_table (name: STRING)
		require
			not get_tables.is_empty
		do
			from
				tables.start
			until
				tables.off
			loop
				if tables.item.get_nom.is_equal (name) then
					io.put_string ("%TTabla: ")
					io.put_string (tables.item.get_nom)
					if not tables.item.get_id.is_empty then
						io.put_string ("  Campo Unico: ")
						io.put_string (tables.item.get_id)
					end
					io.put_new_line
					io.put_string ("%TColumnas:[")
					show_columns_table(tables.item)
					io.put_string ("]")
					io.put_new_line
				end

				tables.forth
			end
		end

	show_columns_table (table: TABLA)
		local
			columns: ARRAYED_LIST[COLUMNA]
		do
			columns:=table.get_rows
			from
				columns.start
			until
				columns.off
			loop
				io.put_string (columns.item.get_nom)
				io.put_string (":")
				io.put_string (columns.item.get_type)
				if not columns.islast then
					io.put_string (", ")
				end
				columns.forth
			end
		end


	table_exists (name: STRING) : BOOLEAN
		local
			exists: BOOLEAN
		do
			if tables.is_empty then
				Result:=false
			else
				from
					tables.start
					exists:=false
				until
					tables.off
				loop
					if tables.item.get_nom.is_equal (name) then
						exists:=true
					end
					tables.forth
				end

				Result:=exists
			end
		end


feature -- User input
	execute_cmd (s:STRING)
		local
			tokens: LIST[STRING]
			com, name, type: STRING

		do
			tokens := s.split (' ')

			tokens.start
			com := tokens.item
			if current_command.is_equal ("creartab") then
				if com.is_equal ("ayuda") then
				    ayuda
				elseif com.is_equal ("defcol") then
				    if tokens.count<3 then
				    	io.put_string ("%T-- Error con el comando defcol --")
				    	io.put_new_line
				    	io.put_string ("%T%TSe debe proporcionar el nombre y el tipo de la columna:")
				    	io.put_new_line
				    	io.put_string ("%T%Tdefcol <Nombre columna> <Tipo> %T%T- Crea nueva columna para la tabla que se esta creando")
						io.put_new_line
						io.put_string ("%T%TLos tipos de datos disponibles son: int o str")
						io.put_new_line
				    else
				    	tokens.forth
						name:=tokens.item
						tokens.forth
						type:=tokens.item

						if type.is_equal ("str") or type.is_equal ("int") then
							if new_table.column_exists(name) then
								io.put_string ("%T-- Error con el comando defcol --")
				    			io.put_new_line
				    			io.put_string ("%T%TEl nombre de la columna es repetida")
				    			io.put_new_line
				    			io.put_string ("%T%TIntente con otro nombre")
				    			io.put_new_line
				    		else
				    			defcol (name,type)
							end
						else
							io.put_string ("%T-- Error con el comando defcol --")
				    		io.put_new_line
				    		io.put_string ("%T%TLos tipos de datos disponibles son: int o str")
							io.put_new_line
						end
				    end
				elseif com.is_equal ("fincreartab") then
					if new_table.get_rows.is_empty then
						io.put_string ("%T-- Error con el comando fincreartab --")
				    	io.put_new_line
				    	io.put_string ("%T%TLa tabla no contiene columnas, se debe agregar al menos una columna")
				    	io.put_new_line
					else
						if tokens.count<2 then
							fincreartab
							current_command:="none"
						else
							tokens.forth
							name:=tokens.item
							if new_table.column_exists(name) then
								fincreartabcolumn(name)
								current_command:="none"
							else
								io.put_string ("%T-- Error con el comando fincreartab --")
				    			io.put_new_line
				    			io.put_string ("%T%TLa tabla no contiene la columna con el nombre especificado")
				    			io.put_new_line
				    			io.put_string ("%T%TVuelvalo a intentar con otra columna")
				    			io.put_new_line
							end
						end
					end
				else
				    io.put_string ("%Tcomando_desconocido%N")
				end
			else
				if com.is_equal ("ayuda") then
					current_command:="ayuda"
				    ayuda
				    current_command:="none"
				elseif com.is_equal ("creartab") then
				    current_command:="creartab"
				    if tokens.count<2 then
				    	current_command:="none"
				    	io.put_string ("%T-- Error con el comando creartab --")
				    	io.put_new_line
				    	io.put_string ("%T%TSe debe proporcionar el nombre de la tabla:")
				    	io.put_new_line
				    	io.put_string ("%T%Tcreartab <Nombre tabla> %T%T- Crea nueva tabla con el nombre dado")
				    else
				    	tokens.forth
				    	name:=tokens.item
				    	if table_exists(name) then
				    		current_command:="none"
				    		io.put_string ("%T-- Error con el comando creartab --")
				    		io.put_new_line
				    		io.put_string ("%T%TYa existe una tabla con el mismo nombre")
				    	else
				    		creartab(name)
				    	end

				    end

				elseif com.is_equal ("desc") then
					if tables.is_empty then
						io.put_string ("%T-- Error con el comando desc --")
				    	io.put_new_line
				    	io.put_string ("%T%TNo hay tablas existentes")
					else
						if tokens.count<2 then
							show_all_tables
						else
							tokens.forth
							name:= tokens.item
							if table_exists(name) then
								show_table(name)
							else
								io.put_string ("%T-- Error con el comando desc --")
				    			io.put_new_line
				    			io.put_string ("%T%TNo hay ninguna tabla con el nombre indicado")
							end
						end
					end
				else
					current_command:="none"
				    io.put_string ("%Tcomando_desconocido%N")
				end
			end
		end

feature {NONE} --Implementation
	tables: ARRAYED_LIST[TABLA]
	current_command: STRING
	new_table: TABLA

end
