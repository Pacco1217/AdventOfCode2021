with Ada.Text_IO.Editing;   use Ada.Text_IO;
with Utils;

use type Utils.unsigned_64;

procedure aoc11 is

  type Octopus is
  record
    value   : Integer;
    flashed : Boolean;
  end record;
  Null_Octopus : constant Octopus := (0, False);

  type Octopus_Array is array (Integer range <>) of Octopus;
  type Octopus_Matrix is array(Integer range <>) of Octopus_Array(1..10);

  file     : File_Type;
  fileName : constant string := "/home/Pacco/AdventOfCode2021/11/src/inputTest.txt";
  count    : Integer := 1;
  octopuses : Octopus_Matrix(1..10) := (others => (others => Null_Octopus));
  flashCount : Utils.unsigned_64 := 0;

  procedure printOctopuses (octopuses : in out Octopus_Matrix) is
    package Int_IO is new Integer_IO(Integer);
  begin
    Int_IO.Default_Width := 3;
    for I in octopuses'Range loop
      for J in octopuses(I)'Range loop
        Int_IO.Put (octopuses(I)(J).value);
      end loop;
      Ada.Text_IO.New_Line;
    end loop;
    Ada.Text_IO.New_Line;
  end printOctopuses;

  procedure printOctopusesFlashes(octopuses : in out Octopus_Matrix) is
  begin
    
    for I in octopuses'Range loop
      for J in octopuses(I)'Range loop
        Ada.Text_IO.Put(Boolean'Image(octopuses(I)(J).flashed) & " ");
      end loop;
      Ada.Text_IO.New_Line;
    end loop;
    Ada.Text_IO.New_Line;
  end printOctopusesFlashes;

  function isInRange(x : in Integer;
                     y : in Integer) return Boolean is
  begin
    return (y in octopuses'Range and then x in octopuses(y)'Range);
  end isInRange;

  procedure flash(octopuses  : in out Octopus_Matrix;
                  flashCount : in out Utils.unsigned_64;
                  x          : in Integer;
                  y          : in Integer) is
  begin
    octopuses(y)(x).value := octopuses(y)(x).value + 1;
    if (octopuses(y)(x).flashed) then
      return;
    elsif(octopuses(y)(x).value > 9) then
      flashCount := flashCount + 1;
      octopuses(y)(x).flashed := true;
      -- go thougt neighbours
      -- top right
      if (isInRange (x-1, y-1)) then
        flash (octopuses => octopuses, flashCount => flashCount, x => x-1, y => y-1);
      end if;
      -- top middle
      if (isInRange (x, y-1)) then
        flash (octopuses => octopuses, flashCount => flashCount, x => x, y => y-1);
      end if;
      --top left
      if (isInRange (x, y-1)) then
        flash (octopuses => octopuses, flashCount => flashCount, x => x, y => y-1);
      end if;
      -- middle left
      if (isInRange (x-1, y)) then
        flash (octopuses => octopuses, flashCount => flashCount, x => x-1, y => y);
      end if;
      -- middle right
      if (isInRange (x+1, y)) then
        flash (octopuses => octopuses, flashCount => flashCount, x => x+1, y => y);
      end if;
      -- bottom left
      if (isInRange (x-1, y+1)) then
        flash (octopuses => octopuses, flashCount => flashCount, x => x-1, y => y+1);
      end if;
      -- bottom middle
      if (isInRange (x, y+1)) then
        flash (octopuses => octopuses, flashCount => flashCount, x => x, y => y+1);
      end if;
      -- bottom left
      if (isInRange (x+1, y+1)) then
        flash (octopuses => octopuses, flashCount => flashCount, x => x+1, y => y+1);
      end if;
      return;
    else
      --octopuses(x)(y).value := octopuses(x)(y).value + 1;
      return;
    end if;
  end;

  procedure runStep (octopuses  : in out Octopus_Matrix;
                     flashCount : in out Utils.unsigned_64) is
  begin
    -- Increment all octopuses
    for I in octopuses'Range loop
      for J in octopuses(I)'Range loop
        octopuses(I)(J).value := octopuses(I)(J).value + 1;
      end loop;
    end loop;
    printOctopuses (octopuses);
    -- Compute Flashes
    for I in octopuses'Range loop
      for J in octopuses(I)'Range loop
        if(octopuses(I)(J).value > 9 and not octopuses(I)(J).flashed) then
          flash (octopuses => octopuses, flashCount => flashCount, x => J, y => I);
        end if;
      end loop;
    end loop;
    printOctopusesFlashes(octopuses);
    -- Set 0 and reset Flashes
    for I in octopuses'Range loop
      for J in octopuses(I)'Range loop
        if (octopuses(I)(J).flashed) then
          octopuses(I)(J).value := 0;
          octopuses(I)(J).flashed := False;
        end if;
      end loop;
    end loop;
  end runStep;

begin

  Ada.Text_IO.Put_Line ("aoc11 part1");
  Open (File => file, Mode => In_File, Name => fileName);
  while not End_Of_File(file) loop
    declare
      line : String := Get_Line(file);
    begin
      Ada.Text_IO.Put_Line (line);
      for I in line'Range loop
        octopuses(count)(I).value := Character'Pos(line((I))) - 48;
      end loop;
      count := count + 1;
    end;
  end loop;
  -- Run steps
  for S in 1 .. 2 loop
    Ada.Text_IO.Put_Line(Integer'Image(S));
    runStep (octopuses, flashCount);
    if(S = 1 or S = 2) then
      printOctopuses (octopuses);
    end if; 
  end loop;
  Ada.Text_IO.Put_Line (Utils.unsigned_64'Image(flashCount));

end aoc11;