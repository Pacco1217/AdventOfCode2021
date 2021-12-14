with Text_IO; use Text_IO;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Ada.Containers.Vectors;
with Ada.Containers.Indefinite_Ordered_Maps;

with Utils;

procedure aoc14 is

  package Char_Vector is new Ada.Containers.Vectors
    (Index_Type   => Natural,
     Element_Type => Character);
  
  use Char_Vector;

  package String_Char_Map is new Ada.Containers.Indefinite_Ordered_Maps
    (Key_Type     => String,
     Element_Type => Character);

  use String_Char_Map;


  file           : File_Type;
  fileName       : constant string := "D:\Install\aoc\14\src\input.txt";
  count          : Integer := 0;
  polymer        : Vector;
  polymerSet     : Boolean := False;
  rules          : Map;
  charOccurences : Utils.CharacterOccurenceArray := Utils.Null_CharacterOccurenceArray;

  procedure printPolymer (polymer : in Vector) is
  begin
    for I in 0 .. Integer(polymer.Length)-1 loop
      Text_IO.Put(polymer.Element(I));
    end loop;
    Text_IO.Put_Line("");
  end printPolymer;

  procedure polymerization (polymer : in out Vector) is
    testStr : String(1..2);
    I : Integer := 0;
  begin
    loop
      exit when I > Integer(polymer.Length) -2;
        testStr(1) := polymer.Element(I);
        testStr(2) := polymer.Element(i+1);
        if (rules.Contains(testStr)) then
          polymer.Insert(I+1, rules.Element(testStr));
          I := I+2;
        end if;
    end loop;
  end polymerization;

  procedure countOccurencies(polymer : in Vector;
                             c       : in out Utils.CharacterOccurenceArray) is
  begin
    c := Utils.Null_CharacterOccurenceArray;
    for I in 0 .. Integer(polymer.Length) - 1 loop
      c(polymer.Element(I)) := c(polymer.Element(I)) + 1;
    end loop;
  end countOccurencies;

  function getMinOccurences(c : in Utils.CharacterOccurenceArray) return Integer is
  begin
    for I in c'First .. c'Last loop
      if (c(I) /= 0) then
        return c(I);
      end if;
    end loop;
  end getMinOccurences;

  procedure printOccurencies(c : in Utils.CharacterOccurenceArray) is
  begin
    for I in c'First .. c'Last loop
      Text_IO.Put(Integer'Image(c(I)));
    end loop;
    Text_IO.Put_Line("");
  end printOccurencies;
begin
  Text_IO.Put_Line("aoc14 part1");
  open (file, In_File, fileName);
  while not End_Of_File(file) loop
    declare
      line : String := Get_Line(file);
    begin
      if (not polymerSet) then
        for I in line'Range loop
          polymer.Append(line(I));
        end loop;
        polymerSet := True;
      else
        if (Index_Non_Blank(line) /= 0) then
          rules.Include(line(1..2), line(7));
        end if;
      end if;
    end;
  end loop;
  printPolymer(polymer);
  for I in 1 .. 10 loop
    polymerization(polymer);
    --printPolymer(polymer);
  end loop;
  countOccurencies(polymer, charOccurences);
  printOccurencies(charOccurences);
  Utils.Bubble_Sort(charOccurences);
  Text_IO.Put_Line(Integer'Image(charOccurences(charOccurences'Last) - getMinOccurences(charOccurences)));
  for I in 11 .. 40 loop
    Text_IO.Put_Line(Integer'Image(I));
    polymerization(polymer);
  end loop;
  countOccurencies(polymer, charOccurences);
  printOccurencies(charOccurences);
  Utils.Bubble_Sort(charOccurences);
  Text_IO.Put_Line(Integer'Image(charOccurences(charOccurences'Last) - getMinOccurences(charOccurences)));
end aoc14;