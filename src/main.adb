with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Text_IO; use Ada.Text_IO;
with ada.numerics.discrete_random;

procedure Main is

   type Single_Number_Guess_Range is range 0 .. 9;

   package Rand_Int is new
     ada.numerics.discrete_random(Single_Number_Guess_Range);
   use Rand_Int;
   gen : Generator;

   subtype Guess_Array_Type_Index_Range is Integer range 1 .. 4;

   type Result_Literals_Type is
     (Number_Not_In_Sequence,
      Number_In_Sequence_In_Wrong_Place,
      Number_In_Sequence_In_Correct_Place);

   type Results_Array_Type is array (Guess_Array_Type_Index_Range) of
     Result_Literals_Type;

   Guess_String : String(Guess_Array_Type_Index_Range);

   type Guess_Array_Type is array (Guess_Array_Type_Index_Range) of
     Single_Number_Guess_Range;

   function String_Guess_To_Int_Array
     (Guess_String    : in String;
      Guess_Int_Array : out Guess_Array_Type) return Boolean
   is
      Dummy : Single_Number_Guess_Range;
   begin
      for J in Guess_Array_Type_Index_Range'Range loop
         Dummy := Single_Number_Guess_Range'Value (Guess_String (J .. J));
         Guess_Int_Array (J) := Dummy;
      end loop;
      return True;
   exception
      when others =>
         return False;
   end String_Guess_To_Int_Array;

   Secret_Number_Sequence : Guess_Array_Type;

   Count_Tries : Positive := Positive'First;
begin

   --  Display the title
   Put_Line ("--- AdasMasterMind ---");
   Put_Line ("* = Number not in secret sequence");
   Put_Line ("% = Number in secret sequence but in wrong place");
   Put_Line ("@ = Number in secret sequence and in correct place");

   --  Create the secret sequence of numbers the user needs to find
   reset(gen);
   for J in Guess_Array_Type_Index_Range'Range loop
      Secret_Number_Sequence (J) := random(gen);
   end loop;

   --  for J in Guess_Array_Type_Index_Range'Range loop
   --     Put (Secret_Number_Sequence (J)'Image);
   --  end loop;
   --  Put_Line ("");

   --  Get the initial guess
   get (Guess_String);

   --  Loop asking the user for input until guess = "exit"
   while Guess_String /= "exit" loop

      Count_Tries := Positive'Succ (Count_Tries);

      --  Convert to int array - returns false if conversion failed
      declare
         Guess_Int_Array : Guess_Array_Type;
         Result_Array : Results_Array_Type :=
           (others => Number_Not_In_Sequence);
      begin
         if String_Guess_To_Int_Array (Guess_String, Guess_Int_Array) then

            --  Check for numbers in the correct place
            for J in Guess_Array_Type_Index_Range'Range loop
               if Guess_Int_Array (J) = Secret_Number_Sequence (J) then
                  Result_Array (J) := Number_In_Sequence_In_Correct_Place;
               end if;
            end loop;

            --  Check if any of the numbers are in the sequence but in the
            --  wrong place
            for J in Guess_Array_Type_Index_Range'Range loop
               for K in Guess_Array_Type_Index_Range'Range loop
                  if Guess_Int_Array (J) = Secret_Number_Sequence (K) and
                    (Result_Array (K) = Number_Not_In_Sequence)
                  then
                     Result_Array (J) :=
                       Number_In_Sequence_In_Wrong_Place;
                     exit;
                  end if;
               end loop;
            end loop;
         else

            --  Guess is not a number in the range of 0 to 9999
            Put_Line ("Please enter 4 numbers in the range 0 .. 9");
         end if;

         --  Print the results
         declare
            Found_Sequence : Boolean := True;
         begin
            for J in Guess_Array_Type_Index_Range'Range loop
               case Result_Array (J) is
               when Number_Not_In_Sequence =>
                  Put ("*");
                  Found_Sequence := False;
               when Number_In_Sequence_In_Wrong_Place =>
                  Put ("%");
                  Found_Sequence := False;
               when Number_In_Sequence_In_Correct_Place =>
                  Put ("@");
               end case;
               if J = Guess_Array_Type_Index_Range'Last then
                  Put_Line ("");
               end if;
            end loop;

            --  Check if we have found the sequence
            if Found_Sequence then
               Put_Line
                 ("Congratulations! Solved in " &
                    Count_Tries'Image & Guess_String := "exit";
            else

               -- Not yet found solution therefore get next guess
               get (Guess_String);
            end if;
         end;
      end;
   end loop;

end Main;
