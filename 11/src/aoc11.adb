with Ada.Text_IO.Editing;   use Ada.Text_IO;
with Utils;

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
  fileName : constant string := "D:\Install\aoc\11\src\input.txt";
  count    : Integer := 1;
  octopuses : Octopus_Matrix(1..10) := (others => (others => Null_Octopus));
  flashCount : Integer := 0;
  allFlashed : Boolean := False;
  firstAllFlash : Integer := 0;
  stepCount  : Integer := 1;

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

  function isInRange(row : in Integer;
                     col : in Integer) return Boolean is
  begin
    return (row in octopuses'Range and then col in octopuses(row)'Range);
  end isInRange;

  procedure flash(octopuses  : in out Octopus_Matrix;
                  --flashCount : in out Utils.unsigned_64;
                  flashCount : in out Integer;
                  row        : in Integer;
                  col        : in Integer) is
  begin
    octopuses(row)(col).value := octopuses(row)(col).value + 1;

    if (octopuses(row)(col).flashed) then
      return;
    elsif(octopuses(row)(col).value > 9) then
      flashCount := flashCount + 1;
      octopuses(row)(col).flashed := true;
      -- go thougt neighbours
      -- top right
      if (isInRange (row-1, col-1)) then
        flash (octopuses => octopuses, flashCount => flashCount, row => row-1, col => col-1);
      end if;
      -- top middle
      if (isInRange (row-1, col)) then
        flash (octopuses => octopuses, flashCount => flashCount, row => row-1, col => col);
      end if;
      --top left
      if (isInRange (row-1, col+1)) then
        flash (octopuses => octopuses, flashCount => flashCount, row => row-1, col => col+1);
      end if;
      -- middle left
      if (isInRange (row, col-1)) then
        flash (octopuses => octopuses, flashCount => flashCount, row => row, col => col-1);
      end if;
      -- middle right
      if (isInRange (row, col+1)) then
        flash (octopuses => octopuses, flashCount => flashCount, row => row, col => col+1);
      end if;
      -- bottom left
      if (isInRange (row+1, col-1)) then
        flash (octopuses => octopuses, flashCount => flashCount, row => row+1, col => col-1);
      end if;
      -- bottom middle
      if (isInRange (row+1, col)) then
        flash (octopuses => octopuses, flashCount => flashCount, row => row+1, col => col);
      end if;
      -- bottom left
      if (isInRange (row+1, col+1)) then
        flash (octopuses => octopuses, flashCount => flashCount, row => row+1, col => col+1);
      end if;
    else
      return;
    end if;
  end flash;

  function hasAllFlashed( octopuses : in Octopus_Matrix) return Boolean is
  begin
    for I in octopuses'Range loop
      for J in octopuses(I)'Range loop
        if (not octopuses(I)(J).flashed) then
          return false;
        end if;
      end loop;
    end loop;
    return true;
  end hasAllFlashed;

  procedure runStep (octopuses  : in out Octopus_Matrix;
                     allFlashed : in out Boolean;
                     flashCount : in out Integer) is
  begin
    -- Increment all octopuses
    for I in octopuses'Range loop
      for J in octopuses(I)'Range loop
        octopuses(I)(J).value := octopuses(I)(J).value + 1;
      end loop;
    end loop;

    -- Compute Flashes
    for I in octopuses'Range loop
      for J in octopuses(I)'Range loop
        if(octopuses(I)(J).value > 9 and not octopuses(I)(J).flashed) then
          flash (octopuses => octopuses, flashCount => flashCount, row => I, col => J);
        end if;
      end loop;
    end loop;

    allFlashed := hasAllFlashed(octopuses);
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
      for I in line'Range loop
        octopuses(count)(I).value := Character'Pos(line((I))) - 48;
      end loop;
      count := count + 1;
    end;
  end loop;
  -- Run steps
  for S in 1 .. 100 loop
    --Ada.Text_IO.Put_Line (Integer'Image(S));
    runStep (octopuses, allFlashed, flashCount);
    stepCount := S;
  end loop;

  loop
    runStep (octopuses, allFlashed, flashCount);
    stepCount := stepCount + 1;
    if (firstAllFlash = 0 and allFlashed) then
      firstAllFlash := stepCount;
      exit;
    end if;
  end loop;

  --Ada.Text_IO.Put_Line (Utils.unsigned_64'Image(flashCount));
  Ada.Text_IO.Put_Line (Integer'Image(flashCount));
  Ada.Text_IO.Put_Line ("aoc11 part2");
  Ada.Text_IO.Put_Line (Integer'Image(firstAllFlash));

end aoc11;