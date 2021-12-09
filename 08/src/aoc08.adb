with Text_IO; use Text_IO;
with Utils; use Utils;

with Ada.Containers.Indefinite_Ordered_Maps;

procedure Aoc08 is
  package Integer_Ordered_Maps is new
     Ada.Containers.Indefinite_Ordered_Maps
       (Key_Type        => Integer,
        Element_Type    => Character);

  use Integer_Ordered_Maps;

  type CharacterOccurenceArray is array (Character range 'a' .. 'g') of Integer;
  Null_CharacterOccurenceArray : constant CharacterOccurenceArray := (others => 0);
  
  file     : File_Type;
  fileName : constant string := "/home/Pacco/AdventOfCode2021/08/src/input.txt";

  count : Integer := 0;
  value : Integer := 0;

  DigitMap : Map;
  charOccurence : CharacterOccurenceArray := Null_CharacterOccurenceArray;

  function countString(str : in String) return Integer is
    total     : Integer := 0;
    lastSpace : Integer := str'First - 1;
    nbChar    : Integer := 0;
  begin
    for I in str'Range loop
      if(str(I) = ' ') then
        nbChar := I-1 - lastSpace;
        if(nbChar = 2 or nbChar = 4 or nbChar = 3 or nbChar = 7) then
          total := total + 1;
        end if;
        lastSpace := I;
      end if;
    end loop;
    nbChar := str'Last - lastSpace;
    if(nbChar = 2 or nbChar = 4 or nbChar = 3 or nbChar = 7) then
      total := total + 1;
    end if;
    return total;
  end countString;

  function discoverDigit(str : in String;
                         A   : in CharacterOccurenceArray;
                         M   : in Map) return Integer is
    numberStr : String(1..4);
    index     : Integer := 1;
    charValue : Integer := 0;
    lastSpace : Integer := str'First - 1;
  begin
    for I in str'Range loop
      if(str(I) = ' ') then
        for J in lastSpace+1 .. I-1 loop
          charValue := charValue + A(str(J));
        end loop;
        lastSpace := I;
        numberStr(index) := M(charValue);
        index := index + 1;
        charValue := 0;
      end if;
    end loop;
    for J in lastSpace+1 .. str'Last loop
      charValue := charValue + A(str(J));
    end loop;
    numberStr(index) := M(charValue);
    return Integer'Value(numberStr);
  end discoverDigit;

  procedure computeCharacterOccurence(str : in String ;
                                      A   : in out CharacterOccurenceArray) is
  begin
    for I in str'Range loop
      if (str(I) in A'Range) then
        A(str(I)) := A(str(I)) + 1;
      end if;
    end loop;
  end computeCharacterOccurence;

begin
  Text_IO.Put_Line ("aoc08 part1");
  open (file, In_File, fileName);
    DigitMap.Include (42, '0');
    DigitMap.Include (17, '1');
    DigitMap.Include (34, '2');
    DigitMap.Include (39, '3');
    DigitMap.Include (30, '4');
    DigitMap.Include (37, '5');
    DigitMap.Include (41, '6');
    DigitMap.Include (25, '7');
    DigitMap.Include (49, '8');
    DigitMap.Include (45, '9');

  while not End_Of_File(file) loop
    declare
      line      : String := Get_Line(file);
      lastPart  : String := Utils.removeFirstSpace(Utils.GetLastSplitString(line, '|'));
      firstPart : String := Utils.GetFirstSplitString (line, '|'); 
    begin
      -- Part 1
      count := count + countString (lastPart);
      -- Part 2
      computeCharacterOccurence (firstPart, charOccurence);
      value := value + discoverDigit (lastPart, charOccurence, DigitMap);
      charOccurence := Null_CharacterOccurenceArray;
    end;
  end loop;
    Text_IO.Put_Line("Count : " & Integer'Image(count));
  close(file);
  -- Setup map
  Text_IO.Put_Line("aoc08 part2");
  Text_IO.Put_Line (Integer'Image(value));
end Aoc08;
