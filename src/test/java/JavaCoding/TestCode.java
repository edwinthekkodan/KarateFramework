package JavaCoding;

public class TestCode {
    public static void main(String[] args) {
        String str = "This is Selenium Testing"; 
        String[] words = str.split(" ");
        for (int i = words.length - 1; i >= 0; i--) {
            System.out.print(words[i] + " ");
        }
    }

}
