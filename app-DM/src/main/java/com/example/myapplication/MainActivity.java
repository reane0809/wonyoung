package com.example.myapplication;
import androidx.appcompat.app.AppCompatActivity; 
import android.os.Bundle; 
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;
/*
TextView와 Button을 위젯 클래스로 직접 화면에 구성
 */ 
public class MainActivity extends AppCompatActivity {
    LinearLayout linearLayout; 
    TextView textView; 
    Button button; 

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        init(); //초기화 함수
        setContentView(R.layout.activity_main);
    }
    private void init() {
        linearLayout = new LinearLayout(this);
        linearLayout.setOrientation(LinearLayout.VERTICAL);

        textView = new TextView(this);  //textview를 사용할 장소
        textView.setText("weather");   //텍스트 결정
        textView.setTextSize(60);   //텍스트 사이즈 결정
        linearLayout.addView(textView); // 위젯들을 레이아웃에 viewGroup에 추가
        LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.WRAP_CONTENT);

        button = new Button(this);  //버튼 사용.
        button.setText("O K !");
        button.setTextSize(30);
        button.setLayoutParams(params);
        linearLayout.addView(button); //버튼을 viewGroup에 추가

    }
}
