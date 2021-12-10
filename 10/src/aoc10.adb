with Text_IO; use Text_IO;

with Ada.Containers.Indefinite_Ordered_Maps;
with Ada.Containers.Ordered_Sets;
with Ada.Containers.Doubly_Linked_Lists;

procedure aoc10 is
  package Integer_Ordered_Maps is new
     Ada.Containers.Indefinite_Ordered_Maps
       (Key_Type        => Character,
        Element_Type    => Character);

  use Integer_Ordered_Maps;

  package Char_Integer_Ordered_Maps is new
     Ada.Containers.Indefinite_Ordered_Maps
       (Key_Type        => Character,
        Element_Type    => Integer);

  use Char_Integer_Ordered_Maps;

  package Char_Sets is new
    Ada.Containers.Ordered_Sets
      (Element_Type => Character);

  use Char_Sets;

  package Chuck_List is new
    Ada.Containers.Doubly_Linked_Lists
     (Element_Type => Character);

  use Chuck_List;
  
  type LineStatus is
  record
    isIncomplete : Boolean := false;
    isCorrupted  : Boolean := false;
    isValid      : Boolean := false;
  end record;
  type LineStatusArray is array (Integer range <>) of LineStatus;

  file     : File_Type;
  fileName : constant string := "D:\Install\aoc\10\src\input.txt";

  count         : Integer := 0;
  points        : Integer := 0;
  lineStatusArr : LineStatusArray(1 .. 94);
  charMap       : Integer_Ordered_Maps.Map;
  corrupMap     : Char_Integer_Ordered_Maps.Map;
  charSet       : Set;
  chuckList     : List;
  charList      : List;

  procedure checkChunks(str    : in String;
                        lineS  : in out LineStatus;
                        points : in out Integer;
                        chunkL : in out List) is
    
  begin
    for I in str'Range loop
      if(charSet.Contains(str(I))) then
        chunkL.Append(str(I));
      elsif(Element(charMap, chunkL.Last_Element) = str(I)) then
        chunkL.Delete_Last;
      else
        lineS.isCorrupted := True;
        points := points + Element(corrupMap,str(I));
        return;
      end if;
    end loop;
    lineS.isIncomplete := Integer(chunkL.length) /= 0;
  end checkChunks;

begin
  -- Prepare charMap
  charMap.Include('(',')');
  charMap.Include('[',']');
  charMap.Include('{','}');
  charMap.Include('<','>');

  charSet.Insert('(');
  charSet.Insert('[');
  charSet.Insert('{');
  charSet.Insert('<');

  corrupMap.Insert(')', 3);
  corrupMap.Insert(']', 57);
  corrupMap.Insert('}', 1197);
  corrupMap.Insert('>', 25137);

  Text_IO.Put_Line("aoc10 part1");
  open (file, In_File, fileName);
  while not End_Of_File(file) loop
    declare
      Line : String := Get_Line(file);
    begin
      Text_IO.Put_Line(line);
      count := count + 1;
      chuckList.Clear;
      checkChunks(line, lineStatusArr(count), points, chuckList);
      Text_IO.put_line("Incomplete : " & Boolean'Image(lineStatusArr(count).isIncomplete) & " Corrupted : " & Boolean'Image(lineStatusArr(count).isCorrupted));
    end;
  end loop;
  Text_IO.Put_Line(Integer'Image(points));
end aoc10;
