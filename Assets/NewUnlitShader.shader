Shader "Unlit/NewUnlitShader"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" {}
 
        _Ambient ("Ambient Intensity", Range(0., 1.)) = 0.1
        _AmbColor ("Ambient Color", color) = (1., 1., 1., 1.)
 
        _Diffuse ("Diffuse Intensity", Range(0., 1.)) = 1.
        _DifColor ("Diffuse Color", color) = (1., 1., 1., 1.)
 
        _Shininess ("Shininess", Range(0.1, 50)) = 1.
        _SpecColor ("Specular color", color) = (1., 1., 1., 1.)
 
        _EmissionTex ("Emission texture", 2D) = "gray" {}
        _EmiVal ("Emission Intensity", float) = 0.
        [HDR]_EmiColor ("Emission Color", color) = (1., 1., 1., 1.)

    }
    SubShader
    {

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            // struct appdata
            // {
            //     float4 vertex : POSITION;
            //     float2 uv : TEXCOORD0;
            // };

            struct v2f
            {
                float3 worldNormal:TEXCOORD1;
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D _EmissionTex;
            fixed4 _EmiColor;
            fixed _EmiVal;

            fixed4 _LightColor0;
           
            fixed _Diffuse;
            fixed4 _DifColor;
 
            fixed _Shininess;
            fixed4 _SpecColor;
           
            fixed _Ambient;
            fixed4 _AmbColor;


            v2f vert (appdata_base v)
            {
                v2f o;

                float3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
                o.worldNormal=worldNormal;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float4 worldPos = mul(unity_ObjectToWorld, i.vertex);
                float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
                float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - worldPos.xyz);

                fixed4 amb = _Ambient * _AmbColor;
                fixed4 NdotL = dot(i.worldNormal, lightDir) * _LightColor0;
                fixed4 dif = NdotL * _Diffuse * _DifColor;
                float3 refl = reflect(-lightDir, i.worldNormal);
                fixed4 spec = pow(saturate(dot(refl, viewDir)), _Shininess) * _LightColor0;
                
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                col.rgb *= dif + amb + spec;

                fixed4 emi = tex2D(_EmissionTex, i.uv).r * _EmiColor * _EmiVal;
                col.rgb += emi.rgb;

                // apply fog
                return col;
            }
            ENDCG
        }
    }
}
