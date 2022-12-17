Shader "TK/Material/PBRShader"
{
    Properties
    {

        [MainTexture] _BaseMap("Albedo", 2D) = "white" { }
        [MainColor] _BaseColor("Color", Color) = (1, 1, 1, 1)

        _Cutoff("Alpha Cutoff", Range(0.0, 1.0)) = 0.5

        _Smoothness("Smoothness", Range(0.0, 1.0)) = 0.5
        _SmoothnessTextureChannel("Smoothness texture channel", Float) = 0

        _Metallic("Metallic", Range(0.0, 1.0)) = 0.0
        _MetallicGlossMap("Metallic", 2D) = "white" { }

        _SpecColor("Specular", Color) = (0.2, 0.2, 0.2)
        _SpecGlossMap("Specular", 2D) = "white" { }

        [ToggleOff] _SpecularHighlights("Specular Highlights", Float) = 1.0
        [ToggleOff] _EnvironmentReflections("Environment Reflections", Float) = 1.0

        _BumpScale("Scale", Float) = 1.0
        _BumpMap("Normal Map", 2D) = "bump" { }

        _Parallax("Scale", Range(0.005, 0.08)) = 0.005
        _ParallaxMap("Height Map", 2D) = "black" { }

        _OcclusionStrength("Strength", Range(0.0, 1.0)) = 1.0
        _OcclusionMap("Occlusion", 2D) = "white" { }

        [HDR] _EmissionColor("Color", Color) = (0, 0, 0)
        _EmissionMap("Emission", 2D) = "white" { }

        _DetailMask("Detail Mask", 2D) = "white" { }
        _DetailAlbedoMapScale("Scale", Range(0.0, 2.0)) = 1.0
        _DetailAlbedoMap("Detail Albedo x2", 2D) = "linearGrey" { }
        _DetailNormalMapScale("Scale", Range(0.0, 2.0)) = 1.0
        [Normal] _DetailNormalMap("Normal Map", 2D) = "bump" { }

        // SRP batching compatibility for Clear Coat (Not used in Lit)
        [HideInInspector] _ClearCoatMask("_ClearCoatMask", Float) = 0.0
        [HideInInspector] _ClearCoatSmoothness("_ClearCoatSmoothness", Float) = 0.0

        // Blending state
        _Surface("__surface", Float) = 0.0
        _Blend("__blend", Float) = 0.0
        _Cull("__cull", Float) = 2.0
        [ToggleUI] _AlphaClip("__clip", Float) = 0.0
        [HideInInspector] _SrcBlend("__src", Float) = 1.0
        [HideInInspector] _DstBlend("__dst", Float) = 0.0
         _ZWrite("__zw", Float) = 1.0

        [ToggleUI] _ReceiveShadows("Receive Shadows", Float) = 1.0
        // Editmode props
        _QueueOffset("Queue offset", Float) = 0.0

        // ObsoleteProperties
        [HideInInspector] _MainTex("BaseMap", 2D) = "white" { }
        [HideInInspector] _Color("Base Color", Color) = (1, 1, 1, 1)
        [HideInInspector] _GlossMapScale("Smoothness", Float) = 0.0
        [HideInInspector] _Glossiness("Smoothness", Float) = 0.0
        [HideInInspector] _GlossyReflections("EnvironmentReflections", Float) = 0.0

        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" { }
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" { }
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" { }
    }

    SubShader
    {
        Tags{ "RenderType" = "Opaque" "RenderPipeline" = "UniversalPipeline" "UniversalMaterialType" = "Lit" "IgnoreProjector" = "True" "ShaderModel" = "4.5"}
        LOD 300
        //Surface
        Pass
        {
            Name "ForwardLit"
            Tags{ "LightMode" = "UniversalForward"}
            Blend[_SrcBlend][_DstBlend]
            ZWrite[_ZWrite]
            Cull[_Cull]
            HLSLPROGRAM
            #pragma exclude_renderers gles gles3 glcore
            #pragma target 4.5
            #pragma shader_feature_local _NORMALMAP
            #pragma shader_feature_local _PARALLAXMAP
            #pragma shader_feature_local _RECEIVE_SHADOWS_OFF
            #pragma shader_feature_local _ _DETAIL_MULX2 _DETAIL_SCALED
            #pragma shader_feature_local_fragment _SURFACE_TYPE_TRANSPARENT
            #pragma shader_feature_local_fragment _ALPHATEST_ON
            #pragma shader_feature_local_fragment _ALPHAPREMULTIPLY_ON
            #pragma shader_feature_local_fragment _EMISSION
            #pragma shader_feature_local_fragment _METALLICSPECGLOSSMAP
            #pragma shader_feature_local_fragment _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
            #pragma shader_feature_local_fragment _OCCLUSIONMAP
            #pragma shader_feature_local_fragment _SPECULARHIGHLIGHTS_OFF
            #pragma shader_feature_local_fragment _ENVIRONMENTREFLECTIONS_OFF
            #pragma shader_feature_local_fragment _SPECULAR_SETUP
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
            #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
            #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
            #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
            #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
            #pragma multi_compile_fragment _ _SHADOWS_SOFT
            #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
            #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
            #pragma multi_compile_fragment _ _LIGHT_LAYERS
            #pragma multi_compile_fragment _ _LIGHT_COOKIES
            #pragma multi_compile _ _CLUSTERED_RENDERING
            #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
            #pragma multi_compile _ SHADOWS_SHADOWMASK
            #pragma multi_compile _ DIRLIGHTMAP_COMBINED
            #pragma multi_compile _ LIGHTMAP_ON
            #pragma multi_compile _ DYNAMICLIGHTMAP_ON
            #pragma multi_compile_fog
            #pragma multi_compile_fragment _ DEBUG_DISPLAY
            #pragma multi_compile_instancing
            #pragma instancing_options renderinglayer
            #pragma multi_compile _ DOTS_INSTANCING_ON

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/CommonMaterial.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/SurfaceInput.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/ParallaxMapping.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

#if defined(_DETAIL_MULX2) || defined(_DETAIL_SCALED)
#define _DETAIL
#endif

#if defined(_PARALLAXMAP) && !defined(SHADER_API_GLES)
#define REQUIRES_TANGENT_SPACE_VIEW_DIR_INTERPOLATOR
#endif

#if (defined(_NORMALMAP) || (defined(_PARALLAXMAP) && !defined(REQUIRES_TANGENT_SPACE_VIEW_DIR_INTERPOLATOR))) || defined(_DETAIL)
#define REQUIRES_WORLD_SPACE_TANGENT_INTERPOLATOR
#endif

        TEXTURE2D(_ParallaxMap);        SAMPLER(sampler_ParallaxMap);
        TEXTURE2D(_OcclusionMap);       SAMPLER(sampler_OcclusionMap);
        TEXTURE2D(_DetailMask);         SAMPLER(sampler_DetailMask);
        TEXTURE2D(_DetailAlbedoMap);    SAMPLER(sampler_DetailAlbedoMap);
        TEXTURE2D(_DetailNormalMap);    SAMPLER(sampler_DetailNormalMap);
        TEXTURE2D(_MetallicGlossMap);   SAMPLER(sampler_MetallicGlossMap);
        TEXTURE2D(_SpecGlossMap);       SAMPLER(sampler_SpecGlossMap);
        TEXTURE2D(_ClearCoatMap);       SAMPLER(sampler_ClearCoatMap);

            CBUFFER_START(UnityPerMaterial)
            float4 _BaseMap_ST;
            float4 _DetailAlbedoMap_ST;
            half4 _BaseColor;
            half4 _SpecColor;
            half4 _EmissionColor;
            half _Cutoff;
            half _Smoothness;
            half _Metallic;
            half _BumpScale;
            half _Parallax;
            half _OcclusionStrength;
            half _ClearCoatMask;
            half _ClearCoatSmoothness;
            half _DetailAlbedoMapScale;
            half _DetailNormalMapScale;
            half _Surface;
            CBUFFER_END

#ifdef _SPECULAR_SETUP
#define SAMPLE_METALLICSPECULAR(uv) SAMPLE_TEXTURE2D(_SpecGlossMap, sampler_SpecGlossMap, uv)
#else
#define SAMPLE_METALLICSPECULAR(uv) SAMPLE_TEXTURE2D(_MetallicGlossMap, sampler_MetallicGlossMap, uv)
#endif

            struct Attributes
            {
                float4 positionOS   : POSITION;
                float3 normalOS     : NORMAL;
                float4 tangentOS    : TANGENT;
                float2 texcoord     : TEXCOORD0;
                float2 staticLightmapUV   : TEXCOORD1;
                float2 dynamicLightmapUV  : TEXCOORD2;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct Varyings
            {
                float2 uv                       : TEXCOORD0;

#if defined(REQUIRES_WORLD_SPACE_POS_INTERPOLATOR)
                float3 positionWS               : TEXCOORD1;
#endif

                float3 normalWS                 : TEXCOORD2;
#if defined(REQUIRES_WORLD_SPACE_TANGENT_INTERPOLATOR)
                half4 tangentWS                : TEXCOORD3;    
#endif
                float3 viewDirWS                : TEXCOORD4;

#ifdef _ADDITIONAL_LIGHTS_VERTEX
                half4 fogFactorAndVertexLight   : TEXCOORD5; 
#else
                half  fogFactor                 : TEXCOORD5;
#endif

#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
                float4 shadowCoord              : TEXCOORD6;
#endif

#if defined(REQUIRES_TANGENT_SPACE_VIEW_DIR_INTERPOLATOR)
                half3 viewDirTS                : TEXCOORD7;
#endif

                DECLARE_LIGHTMAP_OR_SH(staticLightmapUV, vertexSH, 8);
#ifdef DYNAMICLIGHTMAP_ON
                float2  dynamicLightmapUV : TEXCOORD9; 
#endif

                float4 positionCS               : SV_POSITION;
                UNITY_VERTEX_INPUT_INSTANCE_ID
                UNITY_VERTEX_OUTPUT_STEREO
            };

            half4 SampleMetallicSpecGloss(float2 uv, half albedoAlpha)
            {
                half4 specGloss;

#ifdef _METALLICSPECGLOSSMAP
                specGloss = half4(SAMPLE_METALLICSPECULAR(uv));
#ifdef _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
                specGloss.a = albedoAlpha * _Smoothness;
#else
                specGloss.a *= _Smoothness;
#endif
#else
#if _SPECULAR_SETUP
                specGloss.rgb = _SpecColor.rgb;
#else
                specGloss.rgb = _Metallic.rrr;
#endif

#ifdef _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
                specGloss.a = albedoAlpha * _Smoothness;
#else
                specGloss.a = _Smoothness;
#endif
#endif

                return specGloss;
            }

            half SampleOcclusion(float2 uv)
            {
#ifdef _OCCLUSIONMAP
#if defined(SHADER_API_GLES)
                return SAMPLE_TEXTURE2D(_OcclusionMap, sampler_OcclusionMap, uv).g;
#else
                half occ = SAMPLE_TEXTURE2D(_OcclusionMap, sampler_OcclusionMap, uv).g;
                return LerpWhiteTo(occ, _OcclusionStrength);
#endif
#else
                return half(1.0);
#endif
            }

            half2 SampleClearCoat(float2 uv)
            {
#if defined(_CLEARCOAT) || defined(_CLEARCOATMAP)
                half2 clearCoatMaskSmoothness = half2(_ClearCoatMask, _ClearCoatSmoothness);

#if defined(_CLEARCOATMAP)
                clearCoatMaskSmoothness *= SAMPLE_TEXTURE2D(_ClearCoatMap, sampler_ClearCoatMap, uv).rg;
#endif

                return clearCoatMaskSmoothness;
#else
                return half2(0.0, 1.0);
#endif  
            }

            void ApplyPerPixelDisplacement(half3 viewDirTS, inout float2 uv)
            {
#if defined(_PARALLAXMAP)
                uv += ParallaxMapping(TEXTURE2D_ARGS(_ParallaxMap, sampler_ParallaxMap), viewDirTS, _Parallax, uv);
#endif
            }

            half3 ScaleDetailAlbedo(half3 detailAlbedo, half scale)
            {
                return half(2.0) * detailAlbedo * scale - scale + half(1.0);
            }

            half3 ApplyDetailAlbedo(float2 detailUv, half3 albedo, half detailMask)
            {
#if defined(_DETAIL)
                half3 detailAlbedo = SAMPLE_TEXTURE2D(_DetailAlbedoMap, sampler_DetailAlbedoMap, detailUv).rgb;

#if defined(_DETAIL_SCALED)
                detailAlbedo = ScaleDetailAlbedo(detailAlbedo, _DetailAlbedoMapScale);
#else
                detailAlbedo = half(2.0) * detailAlbedo;
#endif

                return albedo * LerpWhiteTo(detailAlbedo, detailMask);
#else
                return albedo;
#endif
            }
            half3 ApplyDetailNormal(float2 detailUv, half3 normalTS, half detailMask)
            {
#if defined(_DETAIL)
#if BUMP_SCALE_NOT_SUPPORTED
                half3 detailNormalTS = UnpackNormal(SAMPLE_TEXTURE2D(_DetailNormalMap, sampler_DetailNormalMap, detailUv));
#else
                half3 detailNormalTS = UnpackNormalScale(SAMPLE_TEXTURE2D(_DetailNormalMap, sampler_DetailNormalMap, detailUv), _DetailNormalMapScale);
#endif

                detailNormalTS = normalize(detailNormalTS);

                return lerp(normalTS, BlendNormalRNM(normalTS, detailNormalTS), detailMask);
#else
                return normalTS;
#endif
            }

            inline void InitializeStandardLitSurfaceData(float2 uv, out SurfaceData outSurfaceData)
            {
                half4 albedoAlpha = SampleAlbedoAlpha(uv, TEXTURE2D_ARGS(_BaseMap, sampler_BaseMap));
                outSurfaceData.alpha = Alpha(albedoAlpha.a, _BaseColor, _Cutoff);

                half4 specGloss = SampleMetallicSpecGloss(uv, albedoAlpha.a);
                outSurfaceData.albedo = albedoAlpha.rgb * _BaseColor.rgb;

#if _SPECULAR_SETUP
                outSurfaceData.metallic = half(1.0);
                outSurfaceData.specular = specGloss.rgb;
#else
                outSurfaceData.metallic = specGloss.r;
                outSurfaceData.specular = half3(0.0, 0.0, 0.0);
#endif

                outSurfaceData.smoothness = specGloss.a;
                outSurfaceData.normalTS = SampleNormal(uv, TEXTURE2D_ARGS(_BumpMap, sampler_BumpMap), _BumpScale);
                outSurfaceData.occlusion = SampleOcclusion(uv);
                outSurfaceData.emission = SampleEmission(uv, _EmissionColor.rgb, TEXTURE2D_ARGS(_EmissionMap, sampler_EmissionMap));

#if defined(_CLEARCOAT) || defined(_CLEARCOATMAP)
                half2 clearCoat = SampleClearCoat(uv);
                outSurfaceData.clearCoatMask = clearCoat.r;
                outSurfaceData.clearCoatSmoothness = clearCoat.g;
#else
                outSurfaceData.clearCoatMask = half(0.0);
                outSurfaceData.clearCoatSmoothness = half(0.0);
#endif

#if defined(_DETAIL)
                half detailMask = SAMPLE_TEXTURE2D(_DetailMask, sampler_DetailMask, uv).a;
                float2 detailUv = uv * _DetailAlbedoMap_ST.xy + _DetailAlbedoMap_ST.zw;
                outSurfaceData.albedo = ApplyDetailAlbedo(detailUv, outSurfaceData.albedo, detailMask);
                outSurfaceData.normalTS = ApplyDetailNormal(detailUv, outSurfaceData.normalTS, detailMask);
#endif
            }

            void InitializeInputData(Varyings input, half3 normalTS, out InputData inputData)
            {
                inputData = (InputData)0;

#if defined(REQUIRES_WORLD_SPACE_POS_INTERPOLATOR)
                inputData.positionWS = input.positionWS;
#endif

                half3 viewDirWS = GetWorldSpaceNormalizeViewDir(input.positionWS);
#if defined(_NORMALMAP) || defined(_DETAIL)
                float sgn = input.tangentWS.w;      // should be either +1 or -1
                float3 bitangent = sgn * cross(input.normalWS.xyz, input.tangentWS.xyz);
                half3x3 tangentToWorld = half3x3(input.tangentWS.xyz, bitangent.xyz, input.normalWS.xyz);

#if defined(_NORMALMAP)
                inputData.tangentToWorld = tangentToWorld;
#endif
                inputData.normalWS = TransformTangentToWorld(normalTS, tangentToWorld);
#else
                inputData.normalWS = input.normalWS;
#endif

                inputData.normalWS = NormalizeNormalPerPixel(inputData.normalWS);
                inputData.viewDirectionWS = viewDirWS;

#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
                inputData.shadowCoord = input.shadowCoord;
#elif defined(MAIN_LIGHT_CALCULATE_SHADOWS)
                inputData.shadowCoord = TransformWorldToShadowCoord(inputData.positionWS);
#else
                inputData.shadowCoord = float4(0, 0, 0, 0);
#endif
#ifdef _ADDITIONAL_LIGHTS_VERTEX
                inputData.fogCoord = InitializeInputDataFog(float4(input.positionWS, 1.0), input.fogFactorAndVertexLight.x);
                inputData.vertexLighting = input.fogFactorAndVertexLight.yzw;
#else
                inputData.fogCoord = InitializeInputDataFog(float4(input.positionWS, 1.0), input.fogFactor);
#endif

#if defined(DYNAMICLIGHTMAP_ON)
                inputData.bakedGI = SAMPLE_GI(input.staticLightmapUV, input.dynamicLightmapUV, input.vertexSH, inputData.normalWS);
#else
                inputData.bakedGI = SAMPLE_GI(input.staticLightmapUV, input.vertexSH, inputData.normalWS);
#endif

                inputData.normalizedScreenSpaceUV = GetNormalizedScreenSpaceUV(input.positionCS);
                inputData.shadowMask = SAMPLE_SHADOWMASK(input.staticLightmapUV);

#if defined(DEBUG_DISPLAY)
#if defined(DYNAMICLIGHTMAP_ON)
                inputData.dynamicLightmapUV = input.dynamicLightmapUV;
#endif
#if defined(LIGHTMAP_ON)
                inputData.staticLightmapUV = input.staticLightmapUV;
#else
                inputData.vertexSH = input.vertexSH;
#endif
#endif
            }

            Varyings LitPassVertex(Attributes input)
            {
                Varyings output = (Varyings)0;

                UNITY_SETUP_INSTANCE_ID(input);
                UNITY_TRANSFER_INSTANCE_ID(input, output);
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(output);

                VertexPositionInputs vertexInput = GetVertexPositionInputs(input.positionOS.xyz);

                VertexNormalInputs normalInput = GetVertexNormalInputs(input.normalOS, input.tangentOS);

                half3 vertexLight = VertexLighting(vertexInput.positionWS, normalInput.normalWS);

                half fogFactor = 0;
#if !defined(_FOG_FRAGMENT)
                fogFactor = ComputeFogFactor(vertexInput.positionCS.z);
#endif

                output.uv = TRANSFORM_TEX(input.texcoord, _BaseMap);

                output.normalWS = normalInput.normalWS;
#if defined(REQUIRES_WORLD_SPACE_TANGENT_INTERPOLATOR) || defined(REQUIRES_TANGENT_SPACE_VIEW_DIR_INTERPOLATOR)
                real sign = input.tangentOS.w * GetOddNegativeScale();
                half4 tangentWS = half4(normalInput.tangentWS.xyz, sign);
#endif
#if defined(REQUIRES_WORLD_SPACE_TANGENT_INTERPOLATOR)
                output.tangentWS = tangentWS;
#endif

#if defined(REQUIRES_TANGENT_SPACE_VIEW_DIR_INTERPOLATOR)
                half3 viewDirWS = GetWorldSpaceNormalizeViewDir(vertexInput.positionWS);
                half3 viewDirTS = GetViewDirectionTangentSpace(tangentWS, output.normalWS, viewDirWS);
                output.viewDirTS = viewDirTS;
#endif

                OUTPUT_LIGHTMAP_UV(input.staticLightmapUV, unity_LightmapST, output.staticLightmapUV);
#ifdef DYNAMICLIGHTMAP_ON
                output.dynamicLightmapUV = input.dynamicLightmapUV.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
#endif
                OUTPUT_SH(output.normalWS.xyz, output.vertexSH);
#ifdef _ADDITIONAL_LIGHTS_VERTEX
                output.fogFactorAndVertexLight = half4(fogFactor, vertexLight);
#else
                output.fogFactor = fogFactor;
#endif

#if defined(REQUIRES_WORLD_SPACE_POS_INTERPOLATOR)
                output.positionWS = vertexInput.positionWS;
#endif

#if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
                output.shadowCoord = GetShadowCoord(vertexInput);
#endif

                output.positionCS = vertexInput.positionCS;

                return output;
            }

            half4 LitPassFragment(Varyings input) : SV_Target
            {
                UNITY_SETUP_INSTANCE_ID(input);
                UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input);

#if defined(_PARALLAXMAP)
#if defined(REQUIRES_TANGENT_SPACE_VIEW_DIR_INTERPOLATOR)
                half3 viewDirTS = input.viewDirTS;
#else
                half3 viewDirWS = GetWorldSpaceNormalizeViewDir(input.positionWS);
                half3 viewDirTS = GetViewDirectionTangentSpace(input.tangentWS, input.normalWS, viewDirWS);
#endif
                ApplyPerPixelDisplacement(viewDirTS, input.uv);
#endif

                SurfaceData surfaceData;
                InitializeStandardLitSurfaceData(input.uv, surfaceData);

                InputData inputData;
                InitializeInputData(input, surfaceData.normalTS, inputData);
                SETUP_DEBUG_TEXTURE_DATA(inputData, input.uv, _BaseMap);

#ifdef _DBUFFER
                ApplyDecalToSurfaceData(input.positionCS, surfaceData, inputData);
#endif

                half4 color = UniversalFragmentPBR(inputData, surfaceData);

                color.rgb = MixFog(color.rgb, inputData.fogCoord);
                color.a = OutputAlpha(color.a, _Surface);

                return color;
            }

            #pragma vertex LitPassVertex
            #pragma fragment LitPassFragment

            ENDHLSL
        }
        //ShadowCaster
        Pass
        {
            Name "ShadowCaster"
            Tags{ "LightMode" = "ShadowCaster"}

            ZWrite On
            ZTest LEqual
            ColorMask 0
            Cull[_Cull]

            HLSLPROGRAM
            #pragma exclude_renderers gles gles3 glcore
            #pragma target 4.5
            #pragma shader_feature_local_fragment _ALPHATEST_ON
            #pragma shader_feature_local_fragment _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A

            #pragma multi_compile_instancing
            #pragma multi_compile _ DOTS_INSTANCING_ON

            #pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW

            #pragma vertex ShadowPassVertex
            #pragma fragment ShadowPassFragment

            # include "Packages/com.unity.render-pipelines.universal/Shaders/LitInput.hlsl"
            # include "Packages/com.unity.render-pipelines.universal/Shaders/ShadowCasterPass.hlsl"
            ENDHLSL
        }
        //DepthNormal DepthOnly
        Pass
        {
            Name "DepthOnly"
            Tags{ "LightMode" = "DepthOnly"}

            ZWrite On
            ColorMask 0
            Cull[_Cull]

            HLSLPROGRAM
#pragma exclude_renderers gles gles3 glcore
#pragma target 4.5

#pragma vertex DepthOnlyVertex
#pragma fragment DepthOnlyFragment

            // -------------------------------------
            // Material Keywords
#pragma shader_feature_local_fragment _ALPHATEST_ON
#pragma shader_feature_local_fragment _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A

            //--------------------------------------
            // GPU Instancing
#pragma multi_compile_instancing
#pragma multi_compile _ DOTS_INSTANCING_ON

# include "Packages/com.unity.render-pipelines.universal/Shaders/LitInput.hlsl"
# include "Packages/com.unity.render-pipelines.universal/Shaders/DepthOnlyPass.hlsl"
            ENDHLSL
        }
        //DepthNormal 
        Pass
        {
            Name "DepthNormals"
            Tags{ "LightMode" = "DepthNormals"}

            ZWrite On
            Cull[_Cull]

            HLSLPROGRAM
#pragma exclude_renderers gles gles3 glcore
#pragma target 4.5

#pragma vertex DepthNormalsVertex
#pragma fragment DepthNormalsFragment

            // -------------------------------------
            // Material Keywords
#pragma shader_feature_local _NORMALMAP
#pragma shader_feature_local _PARALLAXMAP
#pragma shader_feature_local _ _DETAIL_MULX2 _DETAIL_SCALED
#pragma shader_feature_local_fragment _ALPHATEST_ON
#pragma shader_feature_local_fragment _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A

            //--------------------------------------
            // GPU Instancing
#pragma multi_compile_instancing
#pragma multi_compile _ DOTS_INSTANCING_ON

# include "Packages/com.unity.render-pipelines.universal/Shaders/LitInput.hlsl"
# include "Packages/com.unity.render-pipelines.universal/Shaders/LitDepthNormalsPass.hlsl"
            ENDHLSL
        }
        //MetaLight
        Pass
        {
            Name "Meta"
            Tags{ "LightMode" = "Meta"}

            Cull Off

            HLSLPROGRAM
            #pragma exclude_renderers gles gles3 glcore
            #pragma target 4.5

            #pragma vertex UniversalVertexMeta
            #pragma fragment UniversalFragmentMetaLit

            #pragma shader_feature EDITOR_VISUALIZATION
            #pragma shader_feature_local_fragment _SPECULAR_SETUP
            #pragma shader_feature_local_fragment _EMISSION
            #pragma shader_feature_local_fragment _METALLICSPECGLOSSMAP
            #pragma shader_feature_local_fragment _ALPHATEST_ON
            #pragma shader_feature_local_fragment _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
            #pragma shader_feature_local _ _DETAIL_MULX2 _DETAIL_SCALED

            #pragma shader_feature_local_fragment _SPECGLOSSMAP

            # include "Packages/com.unity.render-pipelines.universal/Shaders/LitInput.hlsl"
            # include "Packages/com.unity.render-pipelines.universal/Shaders/LitMetaPass.hlsl"

            ENDHLSL
        }
    }
}
