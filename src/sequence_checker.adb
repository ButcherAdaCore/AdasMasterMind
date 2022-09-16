package body Sequence_Checker with SPARK_Mode => On is

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
     (--  Check String length
      if Sequence'Length > Guess_Array_Type_Index_Range'Last then
         String_Too_Long
      elsif Sequence'Length < Guess_Array_Type_Index_Range'Last then
         String_Too_Short
      elsif Sequence = "exit" then
         String_Is_Valid
      elsif not String_Is_Int_Array (Sequence) then
         String_Not_All_Integers
      else
         String_Is_Valid);

   --------------------
   -- Sequence_Found --
   --------------------

   function Sequence_Found (Results : Results_Array_Type) return Boolean is
     (for all Result of Results =>
         Result = Number_In_Sequence_In_Correct_Place);

   -----------------------
   -- Compare_Sequences --
   -----------------------

   function Compare_Sequences
     (Guess_Sequence : String; Check_Sequence : Guess_Int_Array)
      return Results_Array_Type
   is
      --  Convert the string representation into an integer vector
      Guess_Array : constant Guess_Int_Array :=
        String_Guess_To_Int_Vector (Guess_Sequence);
      Result_Array : Results_Array_Type :=
        [others => Number_Not_In_Sequence];
      Check_Sequence_Copy : Guess_Int_Array := Check_Sequence;

   begin
      --  First check for any numbers in the correct place
      for J in Guess_Array_Type_Index_Range'Range loop
         if Guess_Array (J) = Check_Sequence_Copy (J) then
            Result_Array (J) := Number_In_Sequence_In_Correct_Place;
            Check_Sequence_Copy (J) := Found_Value;
         end if;
      end loop;

      --  Check if any of the numbers are in the sequence but in the
      --  wrong place - don't override any of the previous results!
      for J in Guess_Array_Type_Index_Range'Range loop
         if Result_Array (J) = Number_Not_In_Sequence then
            for K in Guess_Array_Type_Index_Range'Range loop
               if Guess_Array (J) = Check_Sequence_Copy (K) then
                  Result_Array (J) := Number_In_Sequence_In_Wrong_Place;
                  exit;
               end if;
            end loop;
         end if;
      end loop;

      return Result_Array;
   end Compare_Sequences;

end Sequence_Checker;
