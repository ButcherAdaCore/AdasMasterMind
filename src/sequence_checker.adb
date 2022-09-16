package body Sequence_Checker with SPARK_Mode => On is

   -------------------------------------
   -- Convert_Results_To_UTF8_Results --
   -------------------------------------

   function Convert_Results_To_UTF8_Results (Results : Results_Array_Type)
                                             return UTF8_Results
   is
      Result : UTF8_Results;
   begin
      --  Sequence not yet found therefore display the results
      for J in Guess_Array_Type_Index_Range'Range loop
         declare

         begin
            case Results (J) is
               when Number_Not_In_Sequence =>
                  Result (J) := '✖';
               when Number_In_Sequence_In_Wrong_Place =>
                  Result (J) := '?';
               when Number_In_Sequence_In_Correct_Place =>
                  Result (J) := '✓';
            end case;
         end;
      end loop;

      return Result;

   end Convert_Results_To_UTF8_Results;

   -------------------------------
   -- String_Guess_To_Int_Array --
   -------------------------------

   function String_Guess_To_Int_Vector
     (Guess_String : in String) return Guess_Int_Array
   is
      Return_Value : Guess_Int_Array;
   begin
      for J in Guess_Array_Type_Index_Range'Range loop
         Return_Value (J) :=
           Character'Pos (Guess_String (J)) - Character'Pos ('0');
      end loop;

      return Return_Value;
   end String_Guess_To_Int_Vector;

   -------------------------
   -- String_Is_Int_Array --
   -------------------------

   function String_Is_Int_Array (Guess_String : in String) return Boolean is
     (Guess_String'First = Guess_Array_Type_Index_Range'First
       and then Guess_String'Last = Guess_Array_Type_Index_Range'Last
       and then (for all J in Guess_String'Range =>
                   Guess_String (J) in '0' .. '9'));

   -----------------------
   -- Sequence_Is_Valid --
   -----------------------

   function Sequence_Is_Valid (Sequence : in String) return Result_Code is
     ( --  Check String length
      if Sequence = Exit_Request then String_Is_Exit_Code
      elsif Sequence'Length > Guess_Array_Type_Index_Range'Last then
         String_Too_Long
      elsif Sequence'Length < Guess_Array_Type_Index_Range'Last then
         String_Too_Short
      elsif not String_Is_Int_Array (Sequence) then
         String_Not_All_Integers
      else
         String_Is_Valid);

   --------------------
   -- Sequence_Found --
   --------------------

   function Sequence_Found (Results : UTF8_Results) return Boolean is
     (Results = "✓✓✓✓");

   -----------------------
   -- Compare_Sequences --
   -----------------------

   function Compare_Sequences
     (Guess_Sequence : String; Check_Sequence : Guess_Int_Array)
      return UTF8_Results
   is
      --  Convert the string representation into an integer vector
      Guess_Array : constant Guess_Int_Array :=
        String_Guess_To_Int_Vector (Guess_Sequence);
      Result_Array : Results_Array_Type := [others => Number_Not_In_Sequence];
      Check_Sequence_Copy : Guess_Int_Array    := Check_Sequence;

   begin
      --  First check for any numbers in the correct place
      for J in Guess_Array_Type_Index_Range'Range loop
         if Guess_Array (J) = Check_Sequence_Copy (J) then
            Result_Array (J)        := Number_In_Sequence_In_Correct_Place;
            Check_Sequence_Copy (J) := Found_Value;
         end if;
      end loop;

      --  Check if any of the numbers are in the sequence but in the wrong
      --  place. Don't check any numbers that we have already determined are
      --  in the correct place.
      for J in Guess_Array_Type_Index_Range'Range loop
         if Result_Array (J) /= Number_In_Sequence_In_Correct_Place then
            Inner_Loop :
            for K in Guess_Array_Type_Index_Range'Range loop
               if Guess_Array (J) = Check_Sequence_Copy (K) then
                  Result_Array (J) := Number_In_Sequence_In_Wrong_Place;
                  exit Inner_Loop;
               end if;
            end loop Inner_Loop;
         end if;
      end loop;

      return Convert_Results_To_UTF8_Results (Result_Array);
   end Compare_Sequences;

end Sequence_Checker;
