package com.inception.skillsewa.utils;

import java.util.Random;

public class IDGenerator {
    public static String generateID() {
        char[] chars = {'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r',
                's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '1', '2', '3', '4', '5', '6', '7', '8', '9', '0'};
        int len = 10;
        Random random = new Random();
        StringBuilder finalId = new StringBuilder(len);
        for (int i = 0; i < len; i++) {
            finalId.append(chars[random.nextInt(0, chars.length)]);
        }

        return finalId.toString();
    }

//    public static void main(String[] args) {
//        for(int i = 0; i<=10; i++){
//            System.out.println(generateID());
//        }
//    }
}
