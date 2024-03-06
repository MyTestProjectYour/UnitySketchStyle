Shader "Custom/ColorFilter" {
    Properties {
        _MainTex ("Texture", 2D) = "white" {}
        _TargetColor ("Target Color", Color) = (1, 1, 1, 1)
    }
    SubShader {
        Tags { "Queue" = "Transparent" "RenderType" = "Transparent" }
        LOD 100

        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"

            struct appdata {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            fixed4 _TargetColor;

            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                UNITY_TRANSFER_FOG(o, o.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target {
                fixed4 col = tex2D(_MainTex, i.uv);
    
                // �������ƶ�
                bool isRedMatch = abs(col.r - _TargetColor.r) < 0.15;
                bool isGreenMatch = abs(col.g - _TargetColor.g) < 0.15;
                bool isBlueMatch = abs(col.b - _TargetColor.b) < 0.15;
                bool isAlphaMatch = abs(col.a - _TargetColor.a) < 0.15;
    
                // �ж��Ƿ�����
                bool isColorMatch = isRedMatch && isGreenMatch && isBlueMatch && isAlphaMatch;
    
                // ��������Ƶ���ɫ�ͷ��أ����򷵻ذ�ɫ��
                if (isColorMatch) {
                    return col;
                } else {
                    //���Ҫ͸����ȥ�������ע��
                    //discard; 
                    return fixed4(1, 1, 1, 1); 
                }
            }
            ENDCG
        }
    }
}