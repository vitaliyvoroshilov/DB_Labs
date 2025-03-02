PGDMP              
        |            billing    16.3    16.3     �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    17078    billing    DATABASE     {   CREATE DATABASE billing WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
    DROP DATABASE billing;
                postgres    false            �            1255    17139    find_20_5_20() 	   PROCEDURE     �  CREATE PROCEDURE public.find_20_5_20()
    LANGUAGE plpgsql
    AS $$DECLARE
	curs_sub REFCURSOR;
	curs_call REFCURSOR;
	rec_sub RECORD;
	rec_call RECORD;
	rec_call1 RECORD;
	rec_call2 RECORD;
	rec_call3 RECORD;
	dur1 BIGINT;
	dur2 BIGINT;
	dur3 BIGINT;
BEGIN
	OPEN curs_sub FOR
		SELECT *
		FROM subscribers;
	LOOP
		FETCH curs_sub INTO rec_sub;
		EXIT WHEN NOT FOUND;
		RAISE NOTICE 'sub % ', rec_sub.ids;
		dur1 := -1;
		dur2 := -1;
		dur3 := -1;
		rec_call1 := NULL;
		rec_call2 := NULL;
		rec_call3 := NULL;
		OPEN curs_call FOR
			SELECT *
			FROM calls;
		LOOP
			FETCH curs_call INTO rec_call;
			EXIT WHEN NOT FOUND;
			IF rec_call.idsub = rec_sub.ids THEN
				IF dur1 > -1 AND dur2 > -1 AND dur3 = -1 THEN
					dur3 := rec_call.dur;
					rec_call3 := rec_call;	
					RAISE NOTICE 'calls %, %, %', rec_call1.idc, rec_call2.idc, rec_call3.idc;
				END IF;
				IF dur1 > -1 AND dur2 = -1 AND dur3 = -1 THEN
					dur2 := rec_call.dur;
					rec_call2 := rec_call;	
				END IF;
				IF dur1 = -1 AND dur2 = -1 AND dur3 = -1 THEN
					dur1 := rec_call.dur;
					rec_call1 := rec_call;
				END IF;
				IF dur1 > -1 AND dur2 > -1 AND dur3 > -1 THEN
					IF dur1 >= 20 AND dur2 < 5 AND dur3 >= 20 THEN
						INSERT INTO twenty_five_twenty (idcall) VALUES (rec_call2.idc);						
					END IF;
					dur1 := dur2;
					rec_call1 := rec_call2;
					dur2 := dur3;
					rec_call2 := rec_call3;
					dur3 := -1;
					rec_call3 := NULL;
				END IF;
			END IF;
		END LOOP;
		CLOSE curs_call;
	END LOOP;
	CLOSE curs_sub;
END;$$;
 &   DROP PROCEDURE public.find_20_5_20();
       public          postgres    false            �            1255    17152    subscribers_sum_fees() 	   PROCEDURE     K  CREATE PROCEDURE public.subscribers_sum_fees()
    LANGUAGE plpgsql
    AS $$DECLARE
	curs_sub REFCURSOR;
	curs_call REFCURSOR;
	curs_tar REFCURSOR;
	rec_sub RECORD;
	rec_call RECORD;
	rec_tar RECORD;
	dur_sum BIGINT;
	monthmins BIGINT;
	monthfee BIGINT;
	minutefee BIGINT;
	fee BIGINT;
	excess BIGINT;
	excfee BIGINT;
BEGIN
	CREATE TABLE sum_fees (
			idsub BIGINT PRIMARY KEY,
			fee NUMERIC(5, 2)
	);
	OPEN curs_sub FOR
		SELECT *
		FROM subscribers;
	LOOP
		FETCH curs_sub INTO rec_sub;
		EXIT WHEN NOT FOUND;
		dur_sum := 0;
		RAISE NOTICE 'sub % ', rec_sub.ids;
		OPEN curs_call FOR
			SELECT *
			FROM calls;
		LOOP
			FETCH curs_call INTO rec_call;
			EXIT WHEN NOT FOUND;
			IF rec_call.idsub = rec_sub.ids THEN
				dur_sum := dur_sum + rec_call.dur;
			END IF;
		END LOOP;
		CLOSE curs_call;
		RAISE NOTICE 'dur_sum % ', dur_sum;
		OPEN curs_tar FOR
			SELECT *
			FROM tariffs;
		LOOP
			FETCH curs_tar INTO rec_tar;
			EXIT WHEN NOT FOUND;
			IF rec_tar.idt = rec_sub.idtar THEN
				monthmins = rec_tar.monthmins;
				monthfee := rec_tar.monthfee;
				minutefee := rec_tar.minutefee;
				fee := monthfee;
				IF dur_sum >= monthmins THEN
					fee := fee + (dur_sum - monthmins) * minutefee;
				END IF;
			END IF;
		END LOOP;
		CLOSE curs_tar;
		INSERT INTO sum_fees (idsub, fee) VALUES (rec_sub.ids, fee);
	END LOOP;
	CLOSE curs_sub;
END;$$;
 .   DROP PROCEDURE public.subscribers_sum_fees();
       public          postgres    false            �            1259    17105    calls    TABLE     �   CREATE TABLE public.calls (
    idc bigint NOT NULL,
    idsub bigint NOT NULL,
    date date NOT NULL,
    dur bigint NOT NULL
);
    DROP TABLE public.calls;
       public         heap    postgres    false            �            1259    17093    subscribers    TABLE     �   CREATE TABLE public.subscribers (
    ids bigint NOT NULL,
    fn character varying NOT NULL,
    ln character varying NOT NULL,
    idtar bigint NOT NULL
);
    DROP TABLE public.subscribers;
       public         heap    postgres    false            �            1259    17115    billing    VIEW        CREATE VIEW public.billing AS
 SELECT ids,
    fn,
    ln,
    idtar,
    COALESCE(( SELECT sum(calls.dur) AS sum
           FROM public.calls
          WHERE (calls.idsub = subscribers.ids)), ((0)::bigint)::numeric) AS calling
   FROM public.subscribers;
    DROP VIEW public.billing;
       public          postgres    false    216    217    217    216    216    216            �            1259    17119    subs_avg_dur    VIEW     �   CREATE VIEW public.subs_avg_dur AS
SELECT
    NULL::bigint AS ids,
    NULL::character varying AS fn,
    NULL::character varying AS ln,
    NULL::bigint AS idtar,
    NULL::numeric AS avg;
    DROP VIEW public.subs_avg_dur;
       public          postgres    false            �            1259    17168    sum_fees    TABLE     R   CREATE TABLE public.sum_fees (
    idsub bigint NOT NULL,
    fee numeric(5,2)
);
    DROP TABLE public.sum_fees;
       public         heap    postgres    false            �            1259    17079    tariffs    TABLE     �   CREATE TABLE public.tariffs (
    idt bigint NOT NULL,
    name character varying NOT NULL,
    monthfee numeric(5,2) NOT NULL,
    monthmins numeric(5,2) NOT NULL,
    minutefee numeric(5,2) NOT NULL
);
    DROP TABLE public.tariffs;
       public         heap    postgres    false            �            1259    17128    tariffs_dur_percentage    VIEW     �   CREATE VIEW public.tariffs_dur_percentage AS
SELECT
    NULL::bigint AS idt,
    NULL::character varying AS name,
    NULL::numeric(5,2) AS monthfee,
    NULL::numeric(5,2) AS monthmins,
    NULL::numeric(5,2) AS minutefee,
    NULL::numeric AS "%";
 )   DROP VIEW public.tariffs_dur_percentage;
       public          postgres    false            �            1259    17123    tariffs_sum_avg_count    VIEW     .  CREATE VIEW public.tariffs_sum_avg_count AS
SELECT
    NULL::bigint AS idt,
    NULL::character varying AS name,
    NULL::numeric(5,2) AS monthfee,
    NULL::numeric(5,2) AS monthmins,
    NULL::numeric(5,2) AS minutefee,
    NULL::numeric AS sum,
    NULL::bigint AS count,
    NULL::numeric AS avg;
 (   DROP VIEW public.tariffs_sum_avg_count;
       public          postgres    false            �            1259    17142    twenty_five_twenty    TABLE     G   CREATE TABLE public.twenty_five_twenty (
    idcall bigint NOT NULL
);
 &   DROP TABLE public.twenty_five_twenty;
       public         heap    postgres    false            �          0    17105    calls 
   TABLE DATA                 public          postgres    false    217   S4       �          0    17093    subscribers 
   TABLE DATA                 public          postgres    false    216   95       �          0    17168    sum_fees 
   TABLE DATA                 public          postgres    false    223   6       �          0    17079    tariffs 
   TABLE DATA                 public          postgres    false    215   y6       �          0    17142    twenty_five_twenty 
   TABLE DATA                 public          postgres    false    222   �6       @           2606    17109    calls calls_pkey 
   CONSTRAINT     O   ALTER TABLE ONLY public.calls
    ADD CONSTRAINT calls_pkey PRIMARY KEY (idc);
 :   ALTER TABLE ONLY public.calls DROP CONSTRAINT calls_pkey;
       public            postgres    false    217            >           2606    17099    subscribers subscribers_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.subscribers
    ADD CONSTRAINT subscribers_pkey PRIMARY KEY (ids);
 F   ALTER TABLE ONLY public.subscribers DROP CONSTRAINT subscribers_pkey;
       public            postgres    false    216            D           2606    17172    sum_fees sum_fees_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.sum_fees
    ADD CONSTRAINT sum_fees_pkey PRIMARY KEY (idsub);
 @   ALTER TABLE ONLY public.sum_fees DROP CONSTRAINT sum_fees_pkey;
       public            postgres    false    223            <           2606    17085    tariffs tariffs_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.tariffs
    ADD CONSTRAINT tariffs_pkey PRIMARY KEY (idt);
 >   ALTER TABLE ONLY public.tariffs DROP CONSTRAINT tariffs_pkey;
       public            postgres    false    215            B           2606    17146 *   twenty_five_twenty twenty_five_twenty_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.twenty_five_twenty
    ADD CONSTRAINT twenty_five_twenty_pkey PRIMARY KEY (idcall);
 T   ALTER TABLE ONLY public.twenty_five_twenty DROP CONSTRAINT twenty_five_twenty_pkey;
       public            postgres    false    222            �           2618    17122    subs_avg_dur _RETURN    RULE       CREATE OR REPLACE VIEW public.subs_avg_dur AS
 SELECT subscribers.ids,
    subscribers.fn,
    subscribers.ln,
    subscribers.idtar,
    avg(calls.dur) AS avg
   FROM (public.subscribers
     LEFT JOIN public.calls ON ((subscribers.ids = calls.idsub)))
  GROUP BY subscribers.ids;
 �   CREATE OR REPLACE VIEW public.subs_avg_dur AS
SELECT
    NULL::bigint AS ids,
    NULL::character varying AS fn,
    NULL::character varying AS ln,
    NULL::bigint AS idtar,
    NULL::numeric AS avg;
       public          postgres    false    216    216    216    216    4670    217    217    219            �           2618    17126    tariffs_sum_avg_count _RETURN    RULE     �  CREATE OR REPLACE VIEW public.tariffs_sum_avg_count AS
 SELECT tariffs.idt,
    tariffs.name,
    tariffs.monthfee,
    tariffs.monthmins,
    tariffs.minutefee,
    sum(calls.dur) AS sum,
    count(calls.*) AS count,
    avg(calls.dur) AS avg
   FROM ((public.tariffs
     LEFT JOIN public.subscribers ON ((subscribers.idtar = tariffs.idt)))
     LEFT JOIN public.calls ON ((subscribers.ids = calls.idsub)))
  GROUP BY tariffs.idt;
 9  CREATE OR REPLACE VIEW public.tariffs_sum_avg_count AS
SELECT
    NULL::bigint AS idt,
    NULL::character varying AS name,
    NULL::numeric(5,2) AS monthfee,
    NULL::numeric(5,2) AS monthmins,
    NULL::numeric(5,2) AS minutefee,
    NULL::numeric AS sum,
    NULL::bigint AS count,
    NULL::numeric AS avg;
       public          postgres    false    216    215    4668    216    215    215    215    215    217    217    220            �           2618    17131    tariffs_dur_percentage _RETURN    RULE     �  CREATE OR REPLACE VIEW public.tariffs_dur_percentage AS
 SELECT tariffs.idt,
    tariffs.name,
    tariffs.monthfee,
    tariffs.monthmins,
    tariffs.minutefee,
    (sum(calls.dur) / ( SELECT sum(calls_1.dur) AS sum
           FROM public.calls calls_1)) AS "%"
   FROM ((public.tariffs
     LEFT JOIN public.subscribers ON ((subscribers.idtar = tariffs.idt)))
     LEFT JOIN public.calls ON ((subscribers.ids = calls.idsub)))
  GROUP BY tariffs.idt;
   CREATE OR REPLACE VIEW public.tariffs_dur_percentage AS
SELECT
    NULL::bigint AS idt,
    NULL::character varying AS name,
    NULL::numeric(5,2) AS monthfee,
    NULL::numeric(5,2) AS monthmins,
    NULL::numeric(5,2) AS minutefee,
    NULL::numeric AS "%";
       public          postgres    false    216    217    217    215    215    215    215    215    4668    216    221            F           2606    17110    calls calls_idsub_fkey    FK CONSTRAINT     z   ALTER TABLE ONLY public.calls
    ADD CONSTRAINT calls_idsub_fkey FOREIGN KEY (idsub) REFERENCES public.subscribers(ids);
 @   ALTER TABLE ONLY public.calls DROP CONSTRAINT calls_idsub_fkey;
       public          postgres    false    216    217    4670            E           2606    17100 "   subscribers subscribers_idtar_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.subscribers
    ADD CONSTRAINT subscribers_idtar_fkey FOREIGN KEY (idtar) REFERENCES public.tariffs(idt);
 L   ALTER TABLE ONLY public.subscribers DROP CONSTRAINT subscribers_idtar_fkey;
       public          postgres    false    4668    216    215            G           2606    17147 1   twenty_five_twenty twenty_five_twenty_idcall_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.twenty_five_twenty
    ADD CONSTRAINT twenty_five_twenty_idcall_fkey FOREIGN KEY (idcall) REFERENCES public.calls(idc);
 [   ALTER TABLE ONLY public.twenty_five_twenty DROP CONSTRAINT twenty_five_twenty_idcall_fkey;
       public          postgres    false    217    4672    222            �   �   x���K�@�὿bvh�3W�V-\a�־\.���7��x
: .��o�~hϣ���$�����v�m�_�z8^�Al���9 ��w)�0<e%$l�E�/"���d#��DD�MK8�I�Z�
�4D�pGC���A����J|B,A8��"����%��H�+,���佚5�8��º8h~��cXj�`hV�#B�<�{u�����&�q��� .u      �   �   x���;�0����lQ����R4��b��i44m$!���w3ݳ|�sIQ����.��6R����aZ4\�����B�(��m��BJa E�]@�vD����L�R�z:x+b@���Y�n��' ^�=���(X�mY|l�� זu\{;ր�s{^�v�$^��{�Pn����x+�S	�:�#~� ����K      �   c   x���v
Q���W((M��L�+.͍OKM-Vs�	uV�0400�Q010�30д��$N�!�Z�t�H�bL�ҵ��(������DK�AZ��pq T)q<      �   n   x���v
Q���W((M��L�+I,�LK+Vs�	uV�0�QP�M�P�Q010�30�Q0�҆@RӚ˓�F@3�R��S�����B�#�c�[2�2��@�BHS�\\ �05�      �   ?   x���v
Q���W((M��L�+)O�+��O�,K����}B]�4�,-���M5���� i�X     