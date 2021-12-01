with TEXT_IO; use TEXT_IO;

procedure aoc01 is
  type arrThree is array (Integer range 0 .. 2) of Integer;
  type Index is mod 3;
  file : File_Type;
  fileName : constant string := "D:\Install\aoc\01\src\input.txt";
  newVal : Integer;
  oldVal : Integer := 99999;
  count : Integer := 0;
  movingArray : arrThree;
  movingIndex : Index := 0;
  procedure fillArray(arr : in out arrThree) is
  begin
    for I in 0 .. 2 loop
     movingArray(I) := Integer'Value(Get_Line(file));
    end loop;
  end fillArray;
  
  function sumArray( arr : in arrThree) return Integer is
    sum : Integer := 0;
  begin
    for I in 0 .. 2 loop
      sum := sum + arr(I);
    end loop;
    return sum;
  end sumArray;
  
  procedure newValue(arr : in out arrThree) is
  begin
    arr(Integer(movingIndex)) := Integer'Value(Get_Line(file));
    movingIndex := movingIndex + 1;
  end newValue;
  
begin
  TEXT_IO.PUT_LINE("aoc01 part1");
  open (file, In_File, fileName);
  while not End_Of_File(file) loop
    newVal := Integer'Value(Get_Line(file));
    if (newVal > oldVal) then
      count := count + 1;
    end if;
    oldVal := newVal;
  end loop;
  TEXT_IO.PUT_LINE("count : " & Integer'Image(count));
  close(file);
  -- RESET data
  oldVal := 99999;
  count := 0;
  TEXT_IO.PUT_LINE("aoc1 part2");
  open (file, In_File, fileName);
  fillArray(movingArray);
  oldVal := sumArray(movingArray);
  while not End_Of_File(file) loop
    newValue(movingArray);
    newVal := sumArray(movingArray);
    if (newVal > oldVal) then
      count := count + 1;
    end if;
    oldVal := newVal;
  end loop;
  TEXT_IO.PUT_LINE("count : " & Integer'Image(count));
  close(file);
end aoc01;