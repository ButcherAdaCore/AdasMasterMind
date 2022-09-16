with Ada.Text_IO; use Ada.Text_IO;
with Sequence_Checker; use Sequence_Checker;

package body User_Input is

   --------------------
   -- Get_User_Input --
   --------------------

   function Get_User_Input return Guess_String_Type_Status is
      Sequence_Valid : Boolean := False;
      String_Sequence : Guess_String_Type_Status;
   begin

      while not Sequence_Valid loop

         Put_Line ("");
         Put_Line ("Enter guess number:" & Count_Tries'Image);
         declare

            --  Get the next guess
            Input_String : constant String := Get_Line;

            --  Check if the inputted data is valid
            Sequence_Validity_Result : constant Result_Code :=
              Sequence_Is_Valid (Sequence => Input_String);
         begin
            case Sequence_Validity_Result is

               when String_Is_Exit_Code =>
                  String_Sequence.Is_Exit_Code := True;
                  Sequence_Valid := True;

               when String_Is_Valid =>
                  Sequence_Valid := True;

                  --  Sequence is valid therefore convert the full range String
                  --  to the subtype
                  String_Sequence.Guess_String :=
                    Input_String (Guess_String_Type'Range);
                  String_Sequence.Is_Exit_Code := False;

               when String_Too_Long | String_Too_Short |
                    String_Not_All_Integers =>
                  Put_Line
                    ("Please enter" & Guess_Array_Type_Index_Range'Last'Image
                     & " numbers in the range 0 .. 9");
            end case;
         end;
      end loop;

      Count_Tries := Positive'Succ (Count_Tries);
      return String_Sequence;

   end Get_User_Input;

   ---------------------
   -- Get_Count_Tries --
   ---------------------

   function Get_Count_Tries return String is (Count_Tries'Image);

end User_Input;
