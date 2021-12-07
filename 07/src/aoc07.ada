with text_io; use text_io;

procedure aoc07 is

  type unsigned_32 is mod 2**32;
  
  type IntegerArray is array(Integer range <>) of unsigned_32;
  MAX_INTEGER : constant unsigned_32 := 2**32 -1;
  
  
  
  file     : File_Type;
  fileName : constant string := "D:\Install\aoc\07\src\input.txt";
  
  arrSize : Integer := 0;
  
  function countValue(str : in String) return Integer is
    count : Integer := 0;
  begin
    for I in str'range loop
      if (str(I) = ',') then
        count := count + 1;
      end if;
    end loop;
    count := count + 1;
    return count;
  end countValue;
  
  procedure getValue(str : in String;
                     arr : in out IntegerArray) is
    count : Integer := 1;
    lastComma : Integer := 0;
  begin
    for I in str'range loop
      if(str(I) = ',') then
        arr(count) := unsigned_32'Value(str(lastComma+1 .. I-1));
        count := count + 1;
        lastComma := I;
      end if;
    end loop;
    arr(count) := unsigned_32'Value(str(lastComma+1 .. str'last));
  end getValue;
  
  function getMin(arr : in IntegerArray) return unsigned_32 is
    min : unsigned_32 := MAX_INTEGER;
  begin
    for I in arr'range loop
      if(arr(I) < min) then
        min := arr(I);
      end if;
    end loop;
    return min;
  end getMin;
  
  function getMax(arr : in IntegerArray) return Integer is
    max : unsigned_32 := 0;
  begin
    for I in arr'range loop
      if(arr(I) > max) then
        max := arr(I);
      end if;
    end loop;
    return Integer(max);
  end getMax;
  
  procedure checkFuel(arr : in IntegerArray;
                      res : in out IntegerArray;
                      pos : in Integer) is
    total    : unsigned_32 := 0;
    checkVal : unsigned_32 := unsigned_32(pos);
  begin
    for I in arr'range loop
      total := total + abs(arr(I) - checkVal);
    end loop;
    res(pos) := total;
  end checkFuel;
  
  procedure checkFuelSecond(arr : in IntegerArray;
                            res : in out IntegerArray;
                            pos : in Integer) is
    total    : unsigned_32 := 0;
    n        : unsigned_32 := 0;
    checkVal : unsigned_32 := unsigned_32(pos);
  begin
    for I in arr'range loop

      n := unsigned_32(abs(Integer(arr(I)) - Integer(checkVal)));
      --text_io.put_line(unsigned_32'Image(arr(I)) & " -> " & unsigned_32'Image(checkVal) & " = " & unsigned_32'Image(unsigned_32(abs(Integer(arr(I)) - Integer(checkVal)))));
      if ((total + (n*(n+1))/2) < total) then
        text_io.put_line("LOOP BACK");
        total := MAX_INTEGER;
        exit;
      else
        total := total + ((n*(n+1))/2);
      end if;
    end loop;
    res(pos) := total;
  end checkFuelSecond;
  
begin
  text_io.put_line("aoc07 part1");
  open (file, In_File, fileName);
  while not End_Of_File(file) loop
    declare
      line : String := Get_Line(file);
    begin
      arrSize := countValue(line);
      
      declare
        inputArr : IntegerArray(1 .. arrSize);
        maxVal   : Integer := 0;
      begin
        getValue(line, inputArr);
        maxVal := getMax(inputArr);
        
        declare
          solutionMinArr : IntegerArray(1..maxVal) := (others => MAX_INTEGER);
          minSolution    : Integer;
        begin
          for I in solutionMinArr'range loop
            checkFuel(inputArr, solutionMinArr, I);
          end loop;
          text_io.put_line("result : " & unsigned_32'Image(getMin(solutionMinArr)));
          -- RESET
          solutionMinArr := (others => MAX_INTEGER);
          text_io.put_line("aoc07 part2");
          for I in solutionMinArr'range loop
            checkFuelSecond(inputArr, solutionMinArr, I);
          end loop;
          text_io.put_line("result : " & unsigned_32'Image(getMin(solutionMinArr)));
        end;
      end;
    end;
  end loop;
  close(file);
end aoc07; 