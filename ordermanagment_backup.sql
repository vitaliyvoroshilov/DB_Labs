PGDMP                      |            ordermanagment    16.3    16.3 A    $           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            %           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            &           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            '           1262    16398    ordermanagment    DATABASE     �   CREATE DATABASE ordermanagment WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
    DROP DATABASE ordermanagment;
                postgres    false            �            1255    16818 Q   add_optional_attribute_in_customers(bigint, character varying, character varying) 	   PROCEDURE       CREATE PROCEDURE public.add_optional_attribute_in_customers(IN arg_id_customer bigint, IN arg_attr_name character varying, IN arg_value character varying)
    LANGUAGE plpgsql
    AS $$DECLARE
	curs REFCURSOR;
	rec RECORD;
BEGIN
	OPEN curs FOR
		SELECT *
		FROM customers_optional_attributes;
	LOOP
		FETCH curs INTO rec;
		EXIT WHEN NOT FOUND;
		UPDATE customers_optional_attributes
			SET relevance = true, value = arg_value
			WHERE id_customer = arg_id_customer
				AND attr_name = arg_attr_name;
	END LOOP;
	CLOSE curs;
END;$$;
 �   DROP PROCEDURE public.add_optional_attribute_in_customers(IN arg_id_customer bigint, IN arg_attr_name character varying, IN arg_value character varying);
       public          postgres    false            �            1255    16833 P   add_optional_attribute_in_products(bigint, character varying, character varying) 	   PROCEDURE       CREATE PROCEDURE public.add_optional_attribute_in_products(IN arg_id_product bigint, IN arg_attr_name character varying, IN arg_value character varying)
    LANGUAGE plpgsql
    AS $$DECLARE
	curs REFCURSOR;
	rec RECORD;
BEGIN
	OPEN curs FOR
		SELECT *
		FROM products_optional_attributes;
	LOOP
		FETCH curs INTO rec;
		EXIT WHEN NOT FOUND;
		UPDATE products_optional_attributes
			SET relevance = true, value = arg_value
			WHERE id_product = arg_id_product
				AND attr_name = arg_attr_name;
	END LOOP;
	CLOSE curs;
END;
$$;
 �   DROP PROCEDURE public.add_optional_attribute_in_products(IN arg_id_product bigint, IN arg_attr_name character varying, IN arg_value character varying);
       public          postgres    false            �            1255    16790 $   cursor_inc_demanded_products_price() 	   PROCEDURE     �  CREATE PROCEDURE public.cursor_inc_demanded_products_price()
    LANGUAGE plpgsql
    AS $$DECLARE
	curs REFCURSOR;
	rec RECORD;
BEGIN
	OPEN curs FOR
		SELECT *
		FROM orders
		WHERE quantity > (
			SELECT AVG(quantity)
			FROM orders
		);
	LOOP
		FETCH curs INTO rec;
		EXIT WHEN NOT FOUND;
		UPDATE products
			SET price = price + 5
			WHERE products.idp = rec.id_product;
	END LOOP;
	CLOSE curs;
END;$$;
 <   DROP PROCEDURE public.cursor_inc_demanded_products_price();
       public          postgres    false            �            1255    16795 (   delete_from_customers_and_orders(bigint) 	   PROCEDURE     �   CREATE PROCEDURE public.delete_from_customers_and_orders(IN arg_idc bigint)
    LANGUAGE plpgsql
    AS $$BEGIN
	DELETE FROM orders
	WHERE id_customer = arg_idc;
	DELETE FROM customers
	WHERE idc = arg_idc;
END;$$;
 K   DROP PROCEDURE public.delete_from_customers_and_orders(IN arg_idc bigint);
       public          postgres    false            �            1255    16796 '   delete_from_products_and_orders(bigint) 	   PROCEDURE     �   CREATE PROCEDURE public.delete_from_products_and_orders(IN arg_idp bigint)
    LANGUAGE plpgsql
    AS $$BEGIN
	DELETE FROM orders
	WHERE id_product = arg_idp;
	DELETE FROM products
	WHERE idp = arg_idp;
END;$$;
 J   DROP PROCEDURE public.delete_from_products_and_orders(IN arg_idp bigint);
       public          postgres    false            �            1255    16768    insert_in_orders()    FUNCTION     �   CREATE FUNCTION public.insert_in_orders() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
	IF NEW.date > CURRENT_TIMESTAMP THEN
		RAISE EXCEPTION 'Incorrect date!';
	END IF;
	RETURN NEW;
END;$$;
 )   DROP FUNCTION public.insert_in_orders();
       public          postgres    false            �            1259    16803    customers_optional_attributes    TABLE     �   CREATE TABLE public.customers_optional_attributes (
    idoa bigint NOT NULL,
    id_customer bigint NOT NULL,
    attr_name character varying NOT NULL,
    relevance boolean NOT NULL,
    value character varying
);
 1   DROP TABLE public.customers_optional_attributes;
       public         heap    postgres    false            �            1259    16802 %   cusomers_optional_attributes_idoa_seq    SEQUENCE     �   CREATE SEQUENCE public.cusomers_optional_attributes_idoa_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 <   DROP SEQUENCE public.cusomers_optional_attributes_idoa_seq;
       public          postgres    false    235            (           0    0 %   cusomers_optional_attributes_idoa_seq    SEQUENCE OWNED BY     p   ALTER SEQUENCE public.cusomers_optional_attributes_idoa_seq OWNED BY public.customers_optional_attributes.idoa;
          public          postgres    false    234            �            1259    16460 	   customers    TABLE     �   CREATE TABLE public.customers (
    idc bigint NOT NULL,
    name character varying(50) NOT NULL,
    address character varying(50) NOT NULL,
    phone character varying(50) NOT NULL,
    contact character varying(50) NOT NULL
);
    DROP TABLE public.customers;
       public         heap    postgres    false            �            1259    16593    customers_3_in_address    VIEW     �   CREATE VIEW public.customers_3_in_address AS
 SELECT idc,
    name,
    address,
    phone,
    contact
   FROM public.customers
  WHERE (((address)::text ~~ '3%'::text) OR ((address)::text ~~ '%3%'::text) OR ((address)::text ~~ '%3'::text));
 )   DROP VIEW public.customers_3_in_address;
       public          postgres    false    216    216    216    216    216            �            1259    16597    customers_3more_words_in_name    VIEW     �   CREATE VIEW public.customers_3more_words_in_name AS
 SELECT idc,
    name,
    address,
    phone,
    contact
   FROM public.customers
  WHERE ((name)::text ~~ '% % %'::text);
 0   DROP VIEW public.customers_3more_words_in_name;
       public          postgres    false    216    216    216    216    216            �            1259    16459    customers_id_seq    SEQUENCE     y   CREATE SEQUENCE public.customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.customers_id_seq;
       public          postgres    false    216            )           0    0    customers_id_seq    SEQUENCE OWNED BY     F   ALTER SEQUENCE public.customers_id_seq OWNED BY public.customers.idc;
          public          postgres    false    215            �            1259    16524    orders    TABLE     �   CREATE TABLE public.orders (
    ido bigint NOT NULL,
    id_customer bigint NOT NULL,
    id_product bigint NOT NULL,
    quantity bigint NOT NULL,
    date date NOT NULL
);
    DROP TABLE public.orders;
       public         heap    postgres    false            �            1259    16561    customers_join_orders    VIEW     �  CREATE VIEW public.customers_join_orders AS
 SELECT customers.idc,
    customers.name,
    customers.address,
    customers.phone,
    customers.contact,
    orders.ido,
    orders.id_customer,
    orders.id_product,
    orders.quantity,
    orders.date
   FROM (public.customers
     JOIN public.orders ON ((customers.idc = orders.id_customer)))
  ORDER BY customers.idc, orders.ido;
 (   DROP VIEW public.customers_join_orders;
       public          postgres    false    216    216    216    216    220    220    220    220    220    216            �            1259    16565    customers_leftjoin_orders    VIEW     �  CREATE VIEW public.customers_leftjoin_orders AS
 SELECT customers.idc,
    customers.name,
    customers.address,
    customers.phone,
    customers.contact,
    orders.ido,
    orders.id_customer,
    orders.id_product,
    orders.quantity,
    orders.date
   FROM (public.customers
     LEFT JOIN public.orders ON ((customers.idc = orders.id_customer)))
  ORDER BY customers.idc, orders.ido;
 ,   DROP VIEW public.customers_leftjoin_orders;
       public          postgres    false    216    220    220    220    220    220    216    216    216    216            �            1259    16577 !   customers_leftjoin_total_quantity    VIEW       CREATE VIEW public.customers_leftjoin_total_quantity AS
SELECT
    NULL::bigint AS idc,
    NULL::character varying(50) AS name,
    NULL::character varying(50) AS address,
    NULL::character varying(50) AS phone,
    NULL::character varying(50) AS contact,
    NULL::numeric AS sum;
 4   DROP VIEW public.customers_leftjoin_total_quantity;
       public          postgres    false            �            1259    16601    customers_with_no_orders    VIEW     x  CREATE VIEW public.customers_with_no_orders AS
 SELECT idc,
    name,
    address,
    phone,
    contact
   FROM public.customers
  WHERE (NOT (EXISTS ( SELECT orders.ido,
            orders.id_customer,
            orders.id_product,
            orders.quantity,
            orders.date
           FROM public.orders
          WHERE (customers.idc = orders.id_customer))));
 +   DROP VIEW public.customers_with_no_orders;
       public          postgres    false    220    220    220    220    220    216    216    216    216    216            �            1259    16589    orders_february    VIEW     �   CREATE VIEW public.orders_february AS
 SELECT ido,
    id_customer,
    id_product,
    quantity,
    date
   FROM public.orders
  WHERE ((date >= '2024-02-01'::date) AND (date <= '2024-02-29'::date))
  ORDER BY date;
 "   DROP VIEW public.orders_february;
       public          postgres    false    220    220    220    220    220            �            1259    16523    orders_id_seq    SEQUENCE     v   CREATE SEQUENCE public.orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.orders_id_seq;
       public          postgres    false    220            *           0    0    orders_id_seq    SEQUENCE OWNED BY     @   ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.ido;
          public          postgres    false    219            �            1259    16512    products    TABLE     �   CREATE TABLE public.products (
    idp bigint NOT NULL,
    price numeric(5,2) NOT NULL,
    shipping boolean NOT NULL,
    description character varying(50) NOT NULL
);
    DROP TABLE public.products;
       public         heap    postgres    false            �            1259    16569    orders_join_products    VIEW     \  CREATE VIEW public.orders_join_products AS
 SELECT orders.ido,
    orders.id_customer,
    orders.id_product,
    orders.quantity,
    orders.date,
    products.idp,
    products.price,
    products.shipping,
    products.description
   FROM (public.orders
     JOIN public.products ON ((orders.id_product = products.idp)))
  ORDER BY orders.date;
 '   DROP VIEW public.orders_join_products;
       public          postgres    false    220    220    220    220    220    218    218    218    218            �            1259    16573    orders_leftjoin_price_mult    VIEW     ]  CREATE VIEW public.orders_leftjoin_price_mult AS
 SELECT orders.ido,
    orders.id_customer,
    orders.id_product,
    orders.quantity,
    orders.date,
    products.price,
    ((orders.quantity)::numeric * products.price) AS sum
   FROM (public.orders
     LEFT JOIN public.products ON ((products.idp = orders.id_product)))
  ORDER BY orders.ido;
 -   DROP VIEW public.orders_leftjoin_price_mult;
       public          postgres    false    218    218    220    220    220    220    220            �            1259    16552    orders_sorted_by_date    VIEW     �   CREATE VIEW public.orders_sorted_by_date AS
 SELECT ido AS id,
    id_customer,
    id_product,
    quantity,
    date
   FROM public.orders
  ORDER BY date;
 (   DROP VIEW public.orders_sorted_by_date;
       public          postgres    false    220    220    220    220    220            �            1259    16585    orders_time_passed    VIEW     �   CREATE VIEW public.orders_time_passed AS
 SELECT ido,
    id_customer,
    id_product,
    quantity,
    date,
    (now() - (date)::timestamp with time zone) AS time_passed
   FROM public.orders
  ORDER BY date;
 %   DROP VIEW public.orders_time_passed;
       public          postgres    false    220    220    220    220    220            �            1259    16636    orders_where_shipping_true    VIEW     #  CREATE VIEW public.orders_where_shipping_true AS
 SELECT ido,
    id_customer,
    id_product,
    quantity,
    date
   FROM public.orders
  WHERE (( SELECT products.shipping
           FROM public.products
          WHERE (orders.id_product = products.idp)) = true)
  ORDER BY id_product;
 -   DROP VIEW public.orders_where_shipping_true;
       public          postgres    false    218    218    220    220    220    220    220            �            1259    16511    products_id_seq    SEQUENCE     x   CREATE SEQUENCE public.products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.products_id_seq;
       public          postgres    false    218            +           0    0    products_id_seq    SEQUENCE OWNED BY     D   ALTER SEQUENCE public.products_id_seq OWNED BY public.products.idp;
          public          postgres    false    217            �            1259    16820    products_optional_attributes    TABLE     �   CREATE TABLE public.products_optional_attributes (
    idpoa bigint NOT NULL,
    id_product bigint NOT NULL,
    attr_name character varying NOT NULL,
    relevance boolean NOT NULL,
    value character varying
);
 0   DROP TABLE public.products_optional_attributes;
       public         heap    postgres    false            �            1259    16819 &   products_optional_attributes_idpoa_seq    SEQUENCE     �   CREATE SEQUENCE public.products_optional_attributes_idpoa_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 =   DROP SEQUENCE public.products_optional_attributes_idpoa_seq;
       public          postgres    false    237            ,           0    0 &   products_optional_attributes_idpoa_seq    SEQUENCE OWNED BY     q   ALTER SEQUENCE public.products_optional_attributes_idpoa_seq OWNED BY public.products_optional_attributes.idpoa;
          public          postgres    false    236            �            1259    16581     products_price_morethan_avgprice    VIEW     �   CREATE VIEW public.products_price_morethan_avgprice AS
SELECT
    NULL::bigint AS idp,
    NULL::numeric(5,2) AS price,
    NULL::boolean AS shipping,
    NULL::character varying(50) AS description,
    NULL::numeric AS avg;
 3   DROP VIEW public.products_price_morethan_avgprice;
       public          postgres    false            h           2604    16463    customers idc    DEFAULT     m   ALTER TABLE ONLY public.customers ALTER COLUMN idc SET DEFAULT nextval('public.customers_id_seq'::regclass);
 <   ALTER TABLE public.customers ALTER COLUMN idc DROP DEFAULT;
       public          postgres    false    215    216    216            k           2604    16806 "   customers_optional_attributes idoa    DEFAULT     �   ALTER TABLE ONLY public.customers_optional_attributes ALTER COLUMN idoa SET DEFAULT nextval('public.cusomers_optional_attributes_idoa_seq'::regclass);
 Q   ALTER TABLE public.customers_optional_attributes ALTER COLUMN idoa DROP DEFAULT;
       public          postgres    false    234    235    235            j           2604    16527 
   orders ido    DEFAULT     g   ALTER TABLE ONLY public.orders ALTER COLUMN ido SET DEFAULT nextval('public.orders_id_seq'::regclass);
 9   ALTER TABLE public.orders ALTER COLUMN ido DROP DEFAULT;
       public          postgres    false    220    219    220            i           2604    16515    products idp    DEFAULT     k   ALTER TABLE ONLY public.products ALTER COLUMN idp SET DEFAULT nextval('public.products_id_seq'::regclass);
 ;   ALTER TABLE public.products ALTER COLUMN idp DROP DEFAULT;
       public          postgres    false    217    218    218            l           2604    16823 "   products_optional_attributes idpoa    DEFAULT     �   ALTER TABLE ONLY public.products_optional_attributes ALTER COLUMN idpoa SET DEFAULT nextval('public.products_optional_attributes_idpoa_seq'::regclass);
 Q   ALTER TABLE public.products_optional_attributes ALTER COLUMN idpoa DROP DEFAULT;
       public          postgres    false    236    237    237                      0    16460 	   customers 
   TABLE DATA           G   COPY public.customers (idc, name, address, phone, contact) FROM stdin;
    public          postgres    false    216   �d                 0    16803    customers_optional_attributes 
   TABLE DATA           g   COPY public.customers_optional_attributes (idoa, id_customer, attr_name, relevance, value) FROM stdin;
    public          postgres    false    235   �f                 0    16524    orders 
   TABLE DATA           N   COPY public.orders (ido, id_customer, id_product, quantity, date) FROM stdin;
    public          postgres    false    220   �g                 0    16512    products 
   TABLE DATA           E   COPY public.products (idp, price, shipping, description) FROM stdin;
    public          postgres    false    218   mi       !          0    16820    products_optional_attributes 
   TABLE DATA           f   COPY public.products_optional_attributes (idpoa, id_product, attr_name, relevance, value) FROM stdin;
    public          postgres    false    237   ~k       -           0    0 %   cusomers_optional_attributes_idoa_seq    SEQUENCE SET     T   SELECT pg_catalog.setval('public.cusomers_optional_attributes_idoa_seq', 41, true);
          public          postgres    false    234            .           0    0    customers_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.customers_id_seq', 12, true);
          public          postgres    false    215            /           0    0    orders_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.orders_id_seq', 66, true);
          public          postgres    false    219            0           0    0    products_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.products_id_seq', 26, true);
          public          postgres    false    217            1           0    0 &   products_optional_attributes_idpoa_seq    SEQUENCE SET     U   SELECT pg_catalog.setval('public.products_optional_attributes_idpoa_seq', 75, true);
          public          postgres    false    236            t           2606    16810 ?   customers_optional_attributes cusomers_optional_attributes_pkey 
   CONSTRAINT        ALTER TABLE ONLY public.customers_optional_attributes
    ADD CONSTRAINT cusomers_optional_attributes_pkey PRIMARY KEY (idoa);
 i   ALTER TABLE ONLY public.customers_optional_attributes DROP CONSTRAINT cusomers_optional_attributes_pkey;
       public            postgres    false    235            n           2606    16465    customers customers_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (idc);
 B   ALTER TABLE ONLY public.customers DROP CONSTRAINT customers_pkey;
       public            postgres    false    216            r           2606    16529    orders orders_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (ido);
 <   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_pkey;
       public            postgres    false    220            v           2606    16827 >   products_optional_attributes products_optional_attributes_pkey 
   CONSTRAINT        ALTER TABLE ONLY public.products_optional_attributes
    ADD CONSTRAINT products_optional_attributes_pkey PRIMARY KEY (idpoa);
 h   ALTER TABLE ONLY public.products_optional_attributes DROP CONSTRAINT products_optional_attributes_pkey;
       public            postgres    false    237            p           2606    16517    products products_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (idp);
 @   ALTER TABLE ONLY public.products DROP CONSTRAINT products_pkey;
       public            postgres    false    218                       2618    16580 )   customers_leftjoin_total_quantity _RETURN    RULE     f  CREATE OR REPLACE VIEW public.customers_leftjoin_total_quantity AS
 SELECT customers.idc,
    customers.name,
    customers.address,
    customers.phone,
    customers.contact,
    sum(orders.quantity) AS sum
   FROM (public.customers
     LEFT JOIN public.orders ON ((customers.idc = orders.id_customer)))
  GROUP BY customers.idc
  ORDER BY customers.idc;
 (  CREATE OR REPLACE VIEW public.customers_leftjoin_total_quantity AS
SELECT
    NULL::bigint AS idc,
    NULL::character varying(50) AS name,
    NULL::character varying(50) AS address,
    NULL::character varying(50) AS phone,
    NULL::character varying(50) AS contact,
    NULL::numeric AS sum;
       public          postgres    false    216    220    220    4718    216    216    216    216    226                       2618    16584 (   products_price_morethan_avgprice _RETURN    RULE     s  CREATE OR REPLACE VIEW public.products_price_morethan_avgprice AS
 SELECT idp,
    price,
    shipping,
    description,
    ( SELECT avg(products_1.price) AS avg
           FROM public.products products_1) AS avg
   FROM public.products
  WHERE (price > ( SELECT avg(products_1.price) AS avg
           FROM public.products products_1))
  GROUP BY idp
  ORDER BY price;
 �   CREATE OR REPLACE VIEW public.products_price_morethan_avgprice AS
SELECT
    NULL::bigint AS idp,
    NULL::numeric(5,2) AS price,
    NULL::boolean AS shipping,
    NULL::character varying(50) AS description,
    NULL::numeric AS avg;
       public          postgres    false    218    218    4720    218    218    227            {           2620    16769    orders insert    TRIGGER     n   CREATE TRIGGER insert BEFORE INSERT ON public.orders FOR EACH ROW EXECUTE FUNCTION public.insert_in_orders();
 &   DROP TRIGGER insert ON public.orders;
       public          postgres    false    220    238            y           2606    16811 K   customers_optional_attributes cusomers_optional_attributes_id_customer_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.customers_optional_attributes
    ADD CONSTRAINT cusomers_optional_attributes_id_customer_fkey FOREIGN KEY (id_customer) REFERENCES public.customers(idc) NOT VALID;
 u   ALTER TABLE ONLY public.customers_optional_attributes DROP CONSTRAINT cusomers_optional_attributes_id_customer_fkey;
       public          postgres    false    235    216    4718            w           2606    16530    orders orders_id_customer_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_id_customer_fkey FOREIGN KEY (id_customer) REFERENCES public.customers(idc) NOT VALID;
 H   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_id_customer_fkey;
       public          postgres    false    220    4718    216            x           2606    16535    orders orders_id_product_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_id_product_fkey FOREIGN KEY (id_product) REFERENCES public.products(idp) NOT VALID;
 G   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_id_product_fkey;
       public          postgres    false    220    218    4720            z           2606    16828 I   products_optional_attributes products_optional_attributes_id_product_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.products_optional_attributes
    ADD CONSTRAINT products_optional_attributes_id_product_fkey FOREIGN KEY (id_product) REFERENCES public.products(idp);
 s   ALTER TABLE ONLY public.products_optional_attributes DROP CONSTRAINT products_optional_attributes_id_product_fkey;
       public          postgres    false    237    218    4720               (  x�E�MO�0��ί�c�ʱ�aK�`!,,E�e/n2j��6r�vïg�"�-��'���dl��Kx�-0���18��RC=y7�Kodת�E��+��"U�����:��~J����wK�M��q�&qbY&2�p�C����h��`��WPq��BkV��E�F���H���`w#~.���i&?x��0�]�O^L؟�Į�l��̊�B
���ԣC�=R`�)m�^����qh�=^���[
�T^I����Lf�%E��_�U�l�l@X����IA��d��ې>Vi��"g΅M�?f)Ȩ"�J�T���@Q�z��cLJv�a��xXһ�7���Of�YU�/bk<��l��BR�T+.�*�]Xm�7I�n͸��)�~j��.��M?tL�s����h�E�"�4oY�BɌ��x�����f�(v�[L����0P�ܙ���� 1R�eFYVi^�=ǎ�{�~��c�)�w�Y����4�v��`laN�h9�JK��.����1�8m1����i��Y��qp��{qQ���J%�95d��Ǿ�0v��I�|��f         �   x�e�K�0Eѱ�T'i>�`��IL�T���P#��\)G��L����vY��t:嵝u���y{�������?�H�0�H�ဪ �R��(YiB�RF�R�ҥJ�������Rv)�F
�K	UK��.e*V*H^��ZjRv)�T��I1�*)F)]JԬ4!y)�j�H�R%|s�IsV%+,�7���Q��W!jG®��0| ����         �  x�U�IrD1C�p��2��p������q��i�-�L���o�O�Ǉ���˿#v�Yb�O���&B�z8��)��)v���O|�f:P��Zul�Do��u	☬8��nM�|�hj[J�~�Z*��T�?N)į��R᰻�����K��+�N����^i�k��Wn����v�Ab�ĥ�3�-ȸIg���	��W����u�N�=#�O��+��<L:���=C?}���9�/r���#��F���Hw�\w����6�`����jrhKfm"�+���QC�P�e���hѴW��17q[�lb��Gm��f��Us@ڡi��J�Zh,�t�ǅ��ܻ(�N�ɾP�\�^�|y���󉦹�	.�^�D}z���I\.E+����8(�góa��n57��N�.|���@�}           x�]R�n�0</���"���2��� 6�K/���Id@Ju���R)Т�����RBQ���^�vxc(-2E7��ڣ���x��?�Z~0�,�R��J.h���0M�VB��,%����ѹ6V\���W��0�
��t����z"�a�G`�T�QcOHK$Mc�����M�d�HRj�������;�{���㹖�<1%A������yđ_[��"Z���f�8�.�yco�	h��~w�h9�0��a4�TR�����⨠6�/MUi�&�;��%�	�t_����D��~"��RHQ�M\���&
��ݽE�������d[]/+Ͳ�jzrY%��+��5���g�s�'�Z�LjЙ�1��j͖ي�`�,!ͅ*H?��nr���o$��C���q���.�y�ȩ�8�) v;���n�Jc�����=fSS�b�N	T�T�{^;2E��+z�Ї�i�I)��1��Bi[9RTɖ�D/�)�B��h �]G��g?c�75�Ҷ      !   J  x�e�KN�@��s�v��q	N0dFqz�4��x�_�$+S�"�����&�ry�*�������������|��o�fh^t<�bHMb�y��|��KK�Do�"8T�2j��C]zF1���В���iA8��̌*b@�!��QGh 84/0��~ם�t���W�5���\��7Q�5���ܐ��Q'kp��-w�y���]S�pw^Hk���s�;����&�s�;��vVאּ��pw��U���s�;��:kp�Ź)��b�5��w���"��ҕ5���>!y/�X��,�Ѽ�>Y�[,�����^Fa�n(�s�;�e4����}$���öm�Ph;     