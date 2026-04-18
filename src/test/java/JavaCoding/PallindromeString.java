package JavaCoding;

public class PallindromeString {
    public static void main(String[] args) {
        String str = "madam"; 
        String reversedStr = "";
        for (int i = str.length() - 1; i >= 0; i--) {
            reversedStr += str.charAt(i);
        }
        if (str.equals(reversedStr)) {
            System.out.println(str + " is a palindrome");
        } else {
            System.out.println(str + " is not a palindrome");
        }
    }
}
