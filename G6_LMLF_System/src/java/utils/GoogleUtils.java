/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package utils;

import com.google.gson.Gson;
import model.GoogleAccount;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;

public class GoogleUtils {

    private GoogleUtils() {
    }

    public static String getToken(String code) throws Exception {

        String response;

        URL url
                = new URL(
                        GoogleConstants.LINK_GET_TOKEN
                );

        HttpURLConnection conn
                = (HttpURLConnection) url.openConnection();

        conn.setRequestMethod("POST");

        conn.setDoOutput(true);

        String params
                = "code=" + code
                + "&client_id=" + GoogleConstants.CLIENT_ID
                + "&client_secret=" + GoogleConstants.CLIENT_SECRET
                + "&redirect_uri=" + GoogleConstants.REDIRECT_URI
                + "&grant_type=" + GoogleConstants.GRANT_TYPE;

        OutputStreamWriter writer
                = new OutputStreamWriter(
                        conn.getOutputStream()
                );

        writer.write(params);

        writer.flush();
        writer.close();

        BufferedReader reader
                = new BufferedReader(
                        new InputStreamReader(
                                conn.getInputStream()
                        )
                );

        StringBuilder sb
                = new StringBuilder();

        String line;

        while ((line = reader.readLine()) != null) {

            sb.append(line);
        }

        response = sb.toString();
        reader.close();
        Gson gson = new Gson();

        TokenResponse token
                = gson.fromJson(
                        response,
                        TokenResponse.class
                );

        return token.getAccess_token();
    }

    private static class TokenResponse {

        private String access_token;

        public String getAccess_token() {
            return access_token;
        }

        public void setAccess_token(
                String access_token) {

            this.access_token
                    = access_token;
        }
    }

    public static GoogleAccount getUserInfo(
            String accessToken)
            throws Exception {

        String link
                = GoogleConstants.LINK_GET_USER_INFO
                + accessToken;

        URL url
                = new URL(link);

        HttpURLConnection conn
                = (HttpURLConnection) url.openConnection();

        conn.setRequestMethod("GET");

        BufferedReader reader
                = new BufferedReader(
                        new InputStreamReader(
                                conn.getInputStream()
                        )
                );

        StringBuilder sb
                = new StringBuilder();

        String line;

        while ((line = reader.readLine()) != null) {

            sb.append(line);
        }
        reader.close();
        Gson gson = new Gson();

        return gson.fromJson(
                sb.toString(),
                GoogleAccount.class
        );
    }
}
