with Ada.Text_IO;
package body Sequence_Generator is

   ------------------------------
   -- Generate_Secret_Sequence --
   ------------------------------

   function Generate_Secret_Sequence return Guess_Int_Array is
      Secret_Number_Sequence : Guess_Int_Array;
   begin
      Rand_Guess_Range.Reset (Random_Generator);
      Secret_Number_Sequence :=
        [others => Rand_Guess_Range.Random (Random_Generator)];

      return Secret_Number_Sequence;
   end Generate_Secret_Sequence;

end Sequence_Generator;
