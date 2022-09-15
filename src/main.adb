
with Common_Types; use Common_Types;
with Sequence_Generator;
with Sequence_Checker;
with Ada.Text_IO; use Ada.Text_IO;
with User_Input;

procedure Main is

   Secret_Number_Sequence : constant Guess_Int_Array :=
     Sequence_Generator.Generate_Secret_Sequence;
   --  Create a new secret sequence

   Guess_String : String (Guess_Array_Type_Index_Range) := "0000";
   --  Used to hold the string representation of the user's guess

begin

   --  Display the title
   Put_Line ("--- AdasMasterMind ---");
   Put_Line ("Key:");
   Put_Line ("   * = Number not in secret sequence");
   Put_Line ("   % = Number in secret sequence but in wrong place");
   Put_Line ("   @ = Number in secret sequence and in correct place");
   Put_Line ("Please enter a 4 digit integer");

   --  Loop asking the user for input until guess = "exit"
   while Guess_String /= "exit" loop

      --  Get the next guess
      Guess_String := User_Input.Get_User_Input;
      exit when Guess_String = "exit";

      declare

         --  Check the inputted sequence against the secret sequence
         Results : constant Sequence_Checker.Results_Array_Type :=
           Sequence_Checker.Compare_Sequences
             (Guess_String, Secret_Number_Sequence);
      begin

         --  Check if we have found the sequence
         if Sequence_Checker.Sequence_Found (Results) then
            Put
              ("Congratulations! Solved in" & User_Input.Get_Count_Tries &
                 "attempts!");
            exit;
         else

            --  Sequence not yet found therefore display the results
            for J in Guess_Array_Type_Index_Range'Range loop
               case Results (J) is
               when Sequence_Checker.Number_Not_In_Sequence =>
                  Put ("*");
               when Sequence_Checker.Number_In_Sequence_In_Wrong_Place =>
                  Put ("%");
               when Sequence_Checker.Number_In_Sequence_In_Correct_Place =>
                  Put ("@");
               end case;
            end loop;
         end if;
      end;
   end loop;

end Main;
