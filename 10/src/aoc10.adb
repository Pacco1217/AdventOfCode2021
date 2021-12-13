with Text_IO; use Text_IO;
with Utils;

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

  use type Utils.unsigned_64;
  
  type LineStatus is
  record
    isIncomplete : Boolean := false;
    isCorrupted  : Boolean := false;
    isValid      : Boolean := false;
  end record;
  type LineStatusArray is array (Integer range <>) of LineStatus;

  file     : File_Type;
  fileName : constant string := "/home/Pacco/AdventOfCode2021/10/src/input.txt";

  count         : Integer := 0;
  points        : Integer := 0;
  completion    : Utils.unsigned_64 := 0;
  incomplete    : Integer := 1;
  lineStatusArr : LineStatusArray(1 .. 94);
  charMap       : Integer_Ordered_Maps.Map;
  corrupMap     : Char_Integer_Ordered_Maps.Map;
  compleMap     : Char_Integer_Ordered_Maps.Map;
  charSet       : Set;
  totalSet      : Set;
  chuckList     : List;

  completionScore : Utils.Unsigned_64_Array(1..47);

  procedure checkChunks(str        : in String;
                        lineS      : in out LineStatus;
                        points     : in out Integer;
                        completion : in out Utils.unsigned_64;
                        chunkL     : in out List) is
  begin
    for I in str'Range loop
      if (totalSet.Contains(str(I))) then
        if(charSet.Contains(str(I))) then
          chunkL.Append(str(I));
        elsif(Element(charMap, chunkL.Last_Element) = str(I)) then
          chunkL.Delete_Last;
        else
          lineS.isCorrupted := True;
          points := points + Element(corrupMap,str(I));
          return;
        end if;
      end if;
    end loop;
    lineS.isIncomplete := Integer(chunkL.length) /= 0;
    -- Compute score for completing line
    completion := 0;
    if(lineS.isIncomplete) then
        while(not chunkL.Is_Empty) loop
          completion := completion * 5;
          completion := completion + Utils.unsigned_64(compleMap.Element(charMap.Element(chunkL.Last_Element)));
          Text_IO.Put_Line(Utils.unsigned_64'Image(completion));
          chunkL.Delete_Last;
        end loop;
    end if;
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

  totalSet.Insert('(');
  totalSet.Insert('[');
  totalSet.Insert('{');
  totalSet.Insert('<');
  totalSet.Insert(')');
  totalSet.Insert(']');
  totalSet.Insert('}');
  totalSet.Insert('>');

  corrupMap.Insert(')', 3);
  corrupMap.Insert(']', 57);
  corrupMap.Insert('}', 1197);
  corrupMap.Insert('>', 25137);
  
  compleMap.Insert(')', 1);
  compleMap.Insert(']', 2);
  compleMap.Insert('}', 3);
  compleMap.Insert('>', 4);

  Text_IO.Put_Line("aoc10 part1");
  open (file, In_File, fileName);
  while not End_Of_File(file) loop
    declare
      Line : String := Get_Line(file);
    begin
      completion := 0;
      Text_IO.Put_Line(line);
      Text_IO.Put_Line(Character'Image(Line(line'Last)));
      count := count + 1;
      chuckList.Clear;
      checkChunks(line, lineStatusArr(count), points, completion, chuckList);
      if(lineStatusArr(count).isIncomplete) then
        completionScore(incomplete) := completion;
        incomplete := incomplete + 1;
      end if;
      Text_IO.put_line("Incomplete : " & Boolean'Image(lineStatusArr(count).isIncomplete) & " Corrupted : " & Boolean'Image(lineStatusArr(count).isCorrupted));
    end;
  end loop;
  Text_IO.Put_Line(Integer'Image(points));
  Text_IO.Put_Line("aoc10 part2");
  Utils.Bubble_Sort (completionScore);
  for I in completionScore'Range loop
    Text_IO.Put_Line (Integer'Image(I) & " " & Utils.unsigned_64'Image(completionScore(I)));
  end loop;
  Text_IO.Put_Line(Utils.unsigned_64'Image(completionScore(completionScore'First + (completionScore'Last - completionScore'First) / 2)));
end aoc10;
