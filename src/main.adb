
with Common_Types; use Common_Types;
with Sequence_Generator;
with Sequence_Checker;
with User_Input;

with Ada.Text_IO;
with Ada.Wide_Wide_Text_IO;

procedure Main is

   Secret_Number_Sequence : constant Guess_Int_Array :=
     Sequence_Generator.Generate_Secret_Sequence;
   --  Create a new secret sequence

   Guess_String_Status : Guess_String_Type_Status;
   --  Used to hold the string representation of the user's guess

begin

   --  Display the title and instructions
   Ada.Text_IO.Put_Line ("--- AdasMasterMind ---"); Ada.Text_IO.Put_Line ("");
   Ada.Text_IO.Put_Line ("Key:");
   Ada.Wide_Wide_Text_IO.Put_Line
     ("   ✖ = Number not in secret sequence");
   Ada.Text_IO.Put_Line
     ("   ? = Number in secret sequence but in wrong place");
   Ada.Wide_Wide_Text_IO.Put_Line
     ("   ✓ = Number in secret sequence and in correct place");
   Ada.Text_IO.Put_Line ("");
   Ada.Text_IO.Put_Line ("Please enter a 4 digit integer or ""exit"" to stop");

   --  Loop asking the user for input until guess = "exit"
   Main_Loop :
   loop

      --  Get the next guess
      Guess_String_Status := User_Input.Get_User_Input;

      --  Stop if the user has entered the exit keyword
      exit Main_Loop when Guess_String_Status.Is_Exit_Code;

      declare

         --  Check the inputted sequence against the secret sequence
         Results : constant UTF8_Results :=
           Sequence_Checker.Compare_Sequences
             (Guess_String_Status.Guess_String, Secret_Number_Sequence);
      begin

         --  Check if we have found the sequence
         if Sequence_Checker.Sequence_Found (Results) then
            Ada.Text_IO.Put_Line ("Congratulations! Solved in" &
                        User_Input.Get_Count_Tries & " attempts!");
            exit Main_Loop;
         else
            Ada.Wide_Wide_Text_IO.Put (Results);
         end if;
      end;
   end loop Main_Loop;

end Main;
