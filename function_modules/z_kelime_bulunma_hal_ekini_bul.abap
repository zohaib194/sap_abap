*--------------------------------------------------------------------*
* Z_KELIME_BULUNMA_HAL_EKINI_BUL
* Kelimenin bulunma hali (-de,-da,-te,-ta) ekini bulur
*--------------------------------------------------------------------*
*
* Türkçe'de ismin hâlleri; kelimeleri belirtme (yükleme), yönelme, 
* bulunma ve ayrılma açısından tanımlayan, sözcüğün yalın hâl ile hâl
* eki almış durumlarından her biridir. 
*
* Türkçe'de ismin beş farklı hâli vardır:
* - Yalın hâli
* - Yönelme hâli  (-e)
* - Belirtme hâli (-i)
* - Bulunma hâli  (-de)
* - Ayrılma hâli  (-den)
*
* Türkçe'de harflerin sınıflandırması aşağıdaki gibidir:
* - Kalın Ünlüler    (a, ı, o, u)
* - İnce Ünlüler     (e, i ,ö, ü)
* - Sert Ünsüzler    (ç, f, h, k, p, s, ş, t)
* - Yumuşak Ünsüzler (b, c, d, g, ğ, j, l, m, n, r, v, y, z)
*
* Bir kelime için bulunma hâli ekinin (-de, -da, -te, -ta) bulunması
* için kelimenin uzunluğuna ve son harflerine bakılır. 
* Aşağıdaki tablolarda kelimenin varsa son üç, yoksa son iki harfine
* bakılarak hangi bulunma hâli ekinin ekleneceği görülmektedir.
*
* Kelime 2 harften oluşuyorsa bulunma hâli eki aşağıdaki gibi tespit edilir;
*
* | Bir önceki harf | Önceki harf | Son harf      | Bulunma hali | Örnekler |
* | --------------- | ----------- | ------------- | ------------ | -------- |
* |                 | Sessiz      | Kalın ünlü    | da           | suda     |
* |                 | Sessiz      | İnce ünlü     | de           |          |
* |                 | Kalın ünlü  | Sert ünsüz    | ta           | aşta     |
* |                 | İnce ünlü   | Sert ünsüz    | te           | işte     |
* |                 | Kalın ünlü  | Yumuşak ünsüz | da           | avda     |
* |                 | İnce ünlü   | Yumuşak ünsüz | de           | evde     |
*
* Kelime 2 harften uzunsa bulunma hâli eki aşağıdaki gibi tespit edilir;
*
* | Bir önceki harf | Önceki harf | Son harf      | Bulunma hali | Örnekler |
* | --------------- | ----------- | ------------- | ------------ | -------- |
* | Herhangi        | Herhangi    | Kalın ünlü    | da           | sobada   |
* | Herhangi        | Herhangi    | İnce ünlü     | de           | örgüde   |
* | Herhangi        | Kalın ünlü  | Sert ünsüz    | ta           | sokakta  |
* | Herhangi        | İnce ünlü   | Sert ünsüz    | te           | piknikte |
* | Kalın ünlü      | Sessiz      | Sert ünsüz    | ta           | altta    |
* | İnce ünlü       | Sessiz      | Sert ünsüz    | te           | üstte    |
* | Herhangi        | Kalın ünlü  | Yumuşak ünsüz | da           | okulda   |
* | Herhangi        | İnce ünlü   | Yumuşak ünsüz | de           | şiirde   |
* | Kalın ünlü      | Sessiz      | Yumuşak ünsüz | da           | tarzda   |
* | İnce ünlü       | Sessiz      | Yumuşak ünsüz | de           |          |
*
*--------------------------------------------------------------------*

FUNCTION z_kelime_bulunma_hal_ekini_bul.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_KELIME) TYPE  STRING
*"  EXPORTING
*"     REFERENCE(EV_EK) TYPE  CHAR2
*"----------------------------------------------------------------------

* Kelimenin bulunma hali (-de,-da,-te,-ta) ekini bul

  CONSTANTS:
    c_sesli(16)       VALUE 'aıouAIOUeiöüEİÖÜ',
    c_sessiz(42)      VALUE 'bcçdfgğhjklmnprsştvyzBCÇDFGĞHJKLMNPRSŞTVYZ',
    c_kalin_sesli(8)  VALUE 'aıouAIOU',
    c_ince_sesli(8)   VALUE 'eiöüEİÖÜ',
    c_sert_sessiz(16) VALUE 'çfhkpsştÇFHKPSŞT',
    c_yumu_sessiz(26) VALUE 'bcdgğjlmnrvyzBCDGĞJLMNRVYZ'.

  DATA:
    lv_kelime          TYPE string,
    lv_len             TYPE i,
    lv_son_harf        TYPE char1,
    lv_onceki_harf     TYPE char1,
    lv_bir_onceki_harf TYPE char1,
    lv_ek              TYPE char2.

  " Kelimenin harf sayısını bul. Harf sayısı 2'den küçükse çık.
  lv_kelime = iv_kelime.
  CONDENSE lv_kelime.
  lv_len = strlen( lv_kelime ).
  CHECK lv_len GE 2.

  " Harf sayısı 2 veya daha fazla ise eklenecek eki tespit et.
  CASE lv_len.

    WHEN 2.
      " Her iki harfe bak
      lv_son_harf    = lv_kelime+1(1).
      lv_onceki_harf = lv_kelime+0(1).

      IF lv_onceki_harf     CA c_sessiz      AND
         lv_son_harf        CA c_kalin_sesli.
        lv_ek = 'da'.
      ENDIF.

      IF lv_onceki_harf     CA c_sessiz      AND
         lv_son_harf        CA c_ince_sesli.
        lv_ek = 'de'.
      ENDIF.

      IF lv_onceki_harf     CA c_kalin_sesli AND
         lv_son_harf        CA c_sert_sessiz.
        lv_ek = 'ta'.
      ENDIF.

      IF lv_onceki_harf     CA c_ince_sesli  AND
         lv_son_harf        CA c_sert_sessiz.
        lv_ek = 'te'.
      ENDIF.

      IF lv_onceki_harf     CA c_kalin_sesli AND
         lv_son_harf        NA c_sert_sessiz AND
         lv_son_harf        NA c_sesli.
        lv_ek = 'da'.
      ENDIF.

      IF lv_onceki_harf     CA c_ince_sesli  AND
         lv_son_harf        NA c_sert_sessiz AND
         lv_son_harf        NA c_sesli.
        lv_ek = 'de'.
      ENDIF.

    WHEN OTHERS.  "GT 2
      " Son üç harfe bak
      lv_len             = lv_len - 1.
      lv_son_harf        = lv_kelime+lv_len(1).
      lv_len             = lv_len - 1.
      lv_onceki_harf     = lv_kelime+lv_len(1).
      lv_len             = lv_len - 1.
      lv_bir_onceki_harf = lv_kelime+lv_len(1).

      IF lv_son_harf        CA c_kalin_sesli.
        lv_ek = 'da'.
      ENDIF.

      IF lv_son_harf        CA c_ince_sesli.
        lv_ek = 'de'.
      ENDIF.

      IF lv_onceki_harf     CA c_kalin_sesli AND
         lv_son_harf        CA c_sert_sessiz.
        lv_ek = 'ta'.
      ENDIF.

      IF lv_onceki_harf     CA c_ince_sesli  AND
         lv_son_harf        CA c_sert_sessiz.
        lv_ek = 'te'.
      ENDIF.

      IF lv_bir_onceki_harf CA c_kalin_sesli AND
         lv_onceki_harf     CA c_sessiz      AND
         lv_son_harf        CA c_sert_sessiz.
        lv_ek = 'ta'.
      ENDIF.

      IF lv_bir_onceki_harf CA c_ince_sesli  AND
         lv_onceki_harf     CA c_sessiz      AND
         lv_son_harf        CA c_sert_sessiz.
        lv_ek = 'te'.
      ENDIF.

      IF lv_onceki_harf     CA c_kalin_sesli AND
         lv_son_harf        NA c_sert_sessiz AND
         lv_son_harf        NA c_sesli.
        lv_ek = 'da'.
      ENDIF.

      IF lv_onceki_harf     CA c_ince_sesli  AND
        lv_son_harf         NA c_sert_sessiz AND
        lv_son_harf         NA c_sesli.
        lv_ek = 'de'.
      ENDIF.

      IF lv_bir_onceki_harf CA c_kalin_sesli AND
         lv_onceki_harf     CA c_sessiz      AND
         lv_son_harf        NA c_sert_sessiz AND
         lv_son_harf        NA c_sesli.
        lv_ek = 'da'.
      ENDIF.

      IF lv_bir_onceki_harf CA c_ince_sesli  AND
         lv_onceki_harf     CA c_sessiz      AND
         lv_son_harf        NA c_sert_sessiz AND
         lv_son_harf        NA c_sesli.
        lv_ek = 'de'.
      ENDIF.
  ENDCASE.

  ev_ek = lv_ek.

ENDFUNCTION.
