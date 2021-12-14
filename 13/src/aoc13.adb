with Text_IO; use Text_IO;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Ada.Containers.Doubly_Linked_Lists;

with Utils; use Utils;


procedure aoc13 is
  type Board_Matrix is array(0 .. 894) of IntegerArray(0 .. 1310);
  --type Board_Matrix is array(0 .. 14) of IntegerArray(0 .. 10);
  type Fold_Type is (Up, Left);
  type Fold_Info is
  record
    foldType : Fold_Type;
    value    : Integer;
  end record;

  package Fold_Info_List is new
    Ada.Containers.Doubly_Linked_Lists
      (Element_Type => Fold_Info);
  
  use Fold_Info_List;

  file     : File_Type;
  fileName : constant string := "D:\Install\aoc\13\src\input.txt";
  count    : Integer := 0;
  boardFull : Boolean := false;
  xPos      : Integer := 0;
  yPos      : Integer := 0;
  xMax      : Integer := 0;
  yMax      : Integer := 0;

  board    : Board_Matrix := (others => (others => 0));
  foldList : List;

  procedure printList (Pos : in Fold_Info_List.Cursor) is
  begin
    Text_IO.Put(Fold_Type'Image(Fold_Info_List.Element(Pos).foldType) & Integer'Image(Fold_Info_List.Element(Pos).value) & " ");
  end printList;

  procedure printBoard(b : in Board_Matrix) is
  begin
    for I in b'Range loop
      for J in b(I)'Range loop
        Text_IO.Put(Integer'Image(b(I)(J)));
      end loop;
      Text_IO.Put_Line("");
    end loop;
  end printBoard;

  procedure fold( b       : in out Board_Matrix;
                  foldInfo : in Fold_Info) is
  newPos : Integer := 0;
  begin
    if (foldInfo.foldType = Left) then
      for I in b'Range loop
        for J in b(I)'Range loop
          if (b(I)(J) = 1) then
            if J > foldInfo.value then 
              newPos := foldInfo.value - (J - foldInfo.value);
              b(I)(newPos) := 1;
              b(I)(J) := 0;
            end if;
          end if;
        end loop;
        b(I)(foldInfo.value) := 0;
      end loop;
    else
      for I in b'Range loop
        for J in b(I)'Range loop
          if (b(I)(J) = 1) then
            if I > foldInfo.value then 
              newPos := foldInfo.value - (I - foldInfo.value);
              b(newPos)(J) := 1;
              b(I)(J) := 0;
            end if;
            if (I = foldInfo.value) then
              b(I)(J) := 0;
            end if;
          end if;
        end loop;
      end loop;
    end if;
  end fold;

  procedure fold(Pos : in Fold_Info_List.Cursor) is
  newPos : Integer := 0;
  begin
    if (Fold_Info_List.Element(Pos).foldType = Left) then
      for I in board'Range loop
        for J in board(I)'Range loop
          if (board(I)(J) = 1) then
            if J > Fold_Info_List.Element(Pos).value then 
              newPos := Fold_Info_List.Element(Pos).value - (J - Fold_Info_List.Element(Pos).value);
              board(I)(newPos) := 1;
              board(I)(J) := 0;
            end if;
          end if;
        end loop;
        board(I)(Fold_Info_List.Element(Pos).value) := 0;
      end loop;
    else
      for I in board'Range loop
        for J in board(I)'Range loop
          if (board(I)(J) = 1) then
            if I > Fold_Info_List.Element(Pos).value then 
              newPos := Fold_Info_List.Element(Pos).value - (I - Fold_Info_List.Element(Pos).value);
              board(newPos)(J) := 1;
              board(I)(J) := 0;
            end if;
            if (I = Fold_Info_List.Element(Pos).value) then
              board(I)(J) := 0;
            end if;
          end if;
        end loop;
      end loop;
    end if;
  end fold;

  function countPoints (b : in Board_Matrix) return Integer is
    total : Integer := 0;
  begin
    for I in b'Range loop
      for J in b(I)'Range loop
        total := total + b(I)(J);
      end loop;
    end loop;
    return total;
  end countPoints;

begin
  Text_IO.Put_Line("aoc13 part1");
  open (file, In_File, fileName);
  while not End_Of_File(file) loop
    declare
      line : String := Get_Line(file);
    begin
      if (Index_Non_Blank(line) /= 0) then
        if (not boardFull) then
          xPos := Integer'Value(Utils.GetFirstSplitString(line, ','));
          if (xPos > xMax) then
            xMax := xPos;
          end if;
          yPos := Integer'Value(Utils.GetLastSplitString(line, ','));
          if (yPos > yMax) then
            yMax := yPos;
          end if;
          -- Mark Board
          board(yPos)(xPos) := 1;
          count := count + 1;
        else
          if (line(12) = 'x') then
            foldList.Append((Left, Integer'Value(line(14..line'Last))));
          else
            foldList.Append((Up, Integer'Value(line(14..line'Last))));
          end if;
        end if;
      else
        boardFull := True;
      end if;
    end;
  end loop;

  fold(board, foldList.First_Element);
  Text_IO.Put_Line(Integer'Image(countPoints(board)));
  Text_IO.Put_Line("aoc13 part2");
  foldList.Iterate(fold'access);
  for I in 0 .. 5 loop
    for J in 0 .. 39 loop
      Text_IO.Put(Integer'Image(board(I)(J)));
    end loop;
    Text_IO.Put_Line("");
  end loop;
end aoc13;