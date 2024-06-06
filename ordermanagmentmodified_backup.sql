PGDMP                       |            ordermanagmentmodified    16.3    16.3 R    ;           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            <           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            =           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            >           1262    16605    ordermanagmentmodified    DATABASE     �   CREATE DATABASE ordermanagmentmodified WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
 &   DROP DATABASE ordermanagmentmodified;
                postgres    false            �            1255    16849 Q   add_optional_attribute_in_customers(bigint, character varying, character varying) 	   PROCEDURE       CREATE PROCEDURE public.add_optional_attribute_in_customers(IN arg_id_customer bigint, IN arg_attr_name character varying, IN arg_value character varying)
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
END;
$$;
 �   DROP PROCEDURE public.add_optional_attribute_in_customers(IN arg_id_customer bigint, IN arg_attr_name character varying, IN arg_value character varying);
       public          postgres    false            �            1255    16864 P   add_optional_attribute_in_products(bigint, character varying, character varying) 	   PROCEDURE       CREATE PROCEDURE public.add_optional_attribute_in_products(IN arg_id_product bigint, IN arg_attr_name character varying, IN arg_value character varying)
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
       public          postgres    false            �            1255    16791 $   cursor_inc_demanded_products_price() 	   PROCEDURE     �  CREATE PROCEDURE public.cursor_inc_demanded_products_price()
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
END;
$$;
 <   DROP PROCEDURE public.cursor_inc_demanded_products_price();
       public          postgres    false            �            1255    16797 (   delete_from_customers_and_orders(bigint) 	   PROCEDURE     �   CREATE PROCEDURE public.delete_from_customers_and_orders(IN arg_idc bigint)
    LANGUAGE plpgsql
    AS $$BEGIN
	DELETE FROM orders
	WHERE id_customer = arg_idc;
	DELETE FROM customers
	WHERE idc = arg_idc;
END; 
$$;
 K   DROP PROCEDURE public.delete_from_customers_and_orders(IN arg_idc bigint);
       public          postgres    false            �            1255    16798 '   delete_from_products_and_orders(bigint) 	   PROCEDURE     �   CREATE PROCEDURE public.delete_from_products_and_orders(IN arg_idp bigint)
    LANGUAGE plpgsql
    AS $$BEGIN
	DELETE FROM orders
	WHERE id_product = arg_idp;
	DELETE FROM products
	WHERE idp = arg_idp;
END; 
$$;
 J   DROP PROCEDURE public.delete_from_products_and_orders(IN arg_idp bigint);
       public          postgres    false            �            1255    16770    insert_in_orders()    FUNCTION     �   CREATE FUNCTION public.insert_in_orders() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
	IF NEW.date > CURRENT_TIMESTAMP THEN
		RAISE EXCEPTION 'Incorrect date!';
	END IF;
	RETURN NEW;
END;
$$;
 )   DROP FUNCTION public.insert_in_orders();
       public          postgres    false            �            1259    16607 	   customers    TABLE     �   CREATE TABLE public.customers (
    idc bigint NOT NULL,
    name character varying(50) NOT NULL,
    address character varying(50) NOT NULL,
    phone character varying(50) NOT NULL,
    contact character varying(50) NOT NULL
);
    DROP TABLE public.customers;
       public         heap    postgres    false            �            1259    16705    customers_3_in_address    VIEW     �   CREATE VIEW public.customers_3_in_address AS
 SELECT idc,
    name,
    address,
    phone,
    contact
   FROM public.customers
  WHERE (((address)::text ~~ '3%'::text) OR ((address)::text ~~ '%3%'::text) OR ((address)::text ~~ '%3'::text));
 )   DROP VIEW public.customers_3_in_address;
       public          postgres    false    216    216    216    216    216            �            1259    16709    customers_3more_words_in_name    VIEW     �   CREATE VIEW public.customers_3more_words_in_name AS
 SELECT idc,
    name,
    address,
    phone,
    contact
   FROM public.customers
  WHERE ((name)::text ~~ '% % %'::text);
 0   DROP VIEW public.customers_3more_words_in_name;
       public          postgres    false    216    216    216    216    216            �            1259    16606    customers_id_seq    SEQUENCE     y   CREATE SEQUENCE public.customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.customers_id_seq;
       public          postgres    false    216            ?           0    0    customers_id_seq    SEQUENCE OWNED BY     F   ALTER SEQUENCE public.customers_id_seq OWNED BY public.customers.idc;
          public          postgres    false    215            �            1259    16648    orders    TABLE     �   CREATE TABLE public.orders (
    ido bigint NOT NULL,
    id_customer bigint NOT NULL,
    id_product bigint NOT NULL,
    id_shipping bigint NOT NULL,
    quantity bigint NOT NULL,
    date date NOT NULL
);
    DROP TABLE public.orders;
       public         heap    postgres    false            �            1259    16673    customers_join_orders    VIEW     �  CREATE VIEW public.customers_join_orders AS
 SELECT customers.idc,
    customers.name,
    customers.address,
    customers.phone,
    customers.contact,
    orders.ido,
    orders.id_customer,
    orders.id_product,
    orders.id_shipping,
    orders.quantity,
    orders.date
   FROM (public.customers
     JOIN public.orders ON ((customers.idc = orders.id_customer)))
  ORDER BY customers.idc, orders.ido;
 (   DROP VIEW public.customers_join_orders;
       public          postgres    false    222    216    216    216    216    216    222    222    222    222    222            �            1259    16677    customers_leftjoin_orders    VIEW     �  CREATE VIEW public.customers_leftjoin_orders AS
 SELECT customers.idc,
    customers.name,
    customers.address,
    customers.phone,
    customers.contact,
    orders.ido,
    orders.id_customer,
    orders.id_product,
    orders.id_shipping,
    orders.quantity,
    orders.date
   FROM (public.customers
     LEFT JOIN public.orders ON ((customers.idc = orders.id_customer)))
  ORDER BY customers.idc, orders.ido;
 ,   DROP VIEW public.customers_leftjoin_orders;
       public          postgres    false    222    222    222    222    222    222    216    216    216    216    216            �            1259    16743 !   customers_leftjoin_total_quantity    VIEW       CREATE VIEW public.customers_leftjoin_total_quantity AS
SELECT
    NULL::bigint AS idc,
    NULL::character varying(50) AS name,
    NULL::character varying(50) AS address,
    NULL::character varying(50) AS phone,
    NULL::character varying(50) AS contact,
    NULL::numeric AS sum;
 4   DROP VIEW public.customers_leftjoin_total_quantity;
       public          postgres    false            �            1259    16835    customers_optional_attributes    TABLE     �   CREATE TABLE public.customers_optional_attributes (
    idcoa bigint NOT NULL,
    id_customer bigint NOT NULL,
    attr_name character varying NOT NULL,
    relevance boolean NOT NULL,
    value character varying
);
 1   DROP TABLE public.customers_optional_attributes;
       public         heap    postgres    false            �            1259    16834 '   customers_optional_attributes_idcoa_seq    SEQUENCE     �   CREATE SEQUENCE public.customers_optional_attributes_idcoa_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 >   DROP SEQUENCE public.customers_optional_attributes_idcoa_seq;
       public          postgres    false    239            @           0    0 '   customers_optional_attributes_idcoa_seq    SEQUENCE OWNED BY     s   ALTER SEQUENCE public.customers_optional_attributes_idcoa_seq OWNED BY public.customers_optional_attributes.idcoa;
          public          postgres    false    238            �            1259    16701    orders_february    VIEW     �   CREATE VIEW public.orders_february AS
 SELECT ido,
    id_customer,
    id_product,
    id_shipping,
    quantity,
    date
   FROM public.orders
  WHERE ((date >= '2024-02-01'::date) AND (date <= '2024-02-29'::date))
  ORDER BY date;
 "   DROP VIEW public.orders_february;
       public          postgres    false    222    222    222    222    222    222            �            1259    16647    orders_id_seq    SEQUENCE     v   CREATE SEQUENCE public.orders_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.orders_id_seq;
       public          postgres    false    222            A           0    0    orders_id_seq    SEQUENCE OWNED BY     @   ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.ido;
          public          postgres    false    221            �            1259    16628    products    TABLE     �   CREATE TABLE public.products (
    idp bigint NOT NULL,
    price numeric(5,2) NOT NULL,
    description character varying(50) NOT NULL
);
    DROP TABLE public.products;
       public         heap    postgres    false            �            1259    16641    shipping_types    TABLE     b   CREATE TABLE public.shipping_types (
    idst bigint NOT NULL,
    price numeric(5,2) NOT NULL
);
 "   DROP TABLE public.shipping_types;
       public         heap    postgres    false            �            1259    16757 (   orders_join_products_join_shipping_types    VIEW     �  CREATE VIEW public.orders_join_products_join_shipping_types AS
 SELECT orders.ido,
    orders.id_customer,
    orders.id_product,
    orders.id_shipping,
    orders.quantity,
    orders.date,
    products.idp,
    products.price,
    products.description,
    shipping_types.price AS shipping_price
   FROM ((public.orders
     JOIN public.products ON ((orders.id_product = products.idp)))
     JOIN public.shipping_types ON ((orders.id_shipping = shipping_types.idst)))
  ORDER BY orders.date;
 ;   DROP VIEW public.orders_join_products_join_shipping_types;
       public          postgres    false    218    218    218    220    220    222    222    222    222    222    222            �            1259    16747 #   orders_leftjoin_price_shipping_mult    VIEW       CREATE VIEW public.orders_leftjoin_price_shipping_mult AS
 SELECT orders.ido,
    orders.id_customer,
    orders.id_product,
    orders.id_shipping,
    orders.quantity,
    orders.date,
    products.price,
    (((orders.quantity)::numeric * products.price) + ( SELECT shipping_types.price
           FROM public.shipping_types
          WHERE (orders.id_shipping = shipping_types.idst))) AS sum
   FROM (public.orders
     LEFT JOIN public.products ON ((products.idp = orders.id_product)))
  ORDER BY orders.ido;
 6   DROP VIEW public.orders_leftjoin_price_shipping_mult;
       public          postgres    false    220    218    218    222    222    222    222    222    222    220            �            1259    16669    orders_sorted_by_date    VIEW     �   CREATE VIEW public.orders_sorted_by_date AS
 SELECT ido AS id,
    id_customer,
    id_product,
    id_shipping,
    quantity,
    date
   FROM public.orders
  ORDER BY date;
 (   DROP VIEW public.orders_sorted_by_date;
       public          postgres    false    222    222    222    222    222    222            �            1259    16697    orders_time_passed    VIEW     �   CREATE VIEW public.orders_time_passed AS
 SELECT ido,
    id_customer,
    id_product,
    id_shipping,
    quantity,
    date,
    age(now(), (date)::timestamp with time zone) AS time_passed
   FROM public.orders
  ORDER BY date;
 %   DROP VIEW public.orders_time_passed;
       public          postgres    false    222    222    222    222    222    222            �            1259    16722    shippings_of_products    TABLE     �   CREATE TABLE public.shippings_of_products (
    idsop bigint NOT NULL,
    id_product bigint NOT NULL,
    id_shipping bigint NOT NULL
);
 )   DROP TABLE public.shippings_of_products;
       public         heap    postgres    false            �            1259    16752    orders_where_shipping_min    VIEW     w  CREATE VIEW public.orders_where_shipping_min AS
 SELECT ido,
    id_customer,
    id_product,
    id_shipping,
    quantity,
    date
   FROM public.orders
  WHERE (id_shipping = ( SELECT min(shippings_of_products.id_shipping) AS min
           FROM public.shippings_of_products
          WHERE (orders.id_product = shippings_of_products.id_product)))
  ORDER BY id_product;
 ,   DROP VIEW public.orders_where_shipping_min;
       public          postgres    false    232    232    222    222    222    222    222    222            �            1259    16627    products_id_seq    SEQUENCE     x   CREATE SEQUENCE public.products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.products_id_seq;
       public          postgres    false    218            B           0    0    products_id_seq    SEQUENCE OWNED BY     D   ALTER SEQUENCE public.products_id_seq OWNED BY public.products.idp;
          public          postgres    false    217            �            1259    16851    products_optional_attributes    TABLE     �   CREATE TABLE public.products_optional_attributes (
    idpoa bigint NOT NULL,
    id_product bigint NOT NULL,
    attr_name character varying NOT NULL,
    relevance boolean NOT NULL,
    value character varying
);
 0   DROP TABLE public.products_optional_attributes;
       public         heap    postgres    false            �            1259    16850 &   products_optional_attributes_idpoa_seq    SEQUENCE     �   CREATE SEQUENCE public.products_optional_attributes_idpoa_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 =   DROP SEQUENCE public.products_optional_attributes_idpoa_seq;
       public          postgres    false    241            C           0    0 &   products_optional_attributes_idpoa_seq    SEQUENCE OWNED BY     q   ALTER SEQUENCE public.products_optional_attributes_idpoa_seq OWNED BY public.products_optional_attributes.idpoa;
          public          postgres    false    240            �            1259    16717     products_price_morethan_avgprice    VIEW     �   CREATE VIEW public.products_price_morethan_avgprice AS
SELECT
    NULL::bigint AS idp,
    NULL::numeric(5,2) AS price,
    NULL::character varying(50) AS description,
    NULL::numeric AS avg;
 3   DROP VIEW public.products_price_morethan_avgprice;
       public          postgres    false            �            1259    16762 !   products_where_all_shipping_types    VIEW       CREATE VIEW public.products_where_all_shipping_types AS
 SELECT idp,
    price,
    description
   FROM public.products
  WHERE (3 = ( SELECT count(*) AS count
           FROM public.shippings_of_products
          WHERE (products.idp = shippings_of_products.id_product)));
 4   DROP VIEW public.products_where_all_shipping_types;
       public          postgres    false    218    218    218    232            �            1259    16640    shippings_id_seq    SEQUENCE     y   CREATE SEQUENCE public.shippings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.shippings_id_seq;
       public          postgres    false    220            D           0    0    shippings_id_seq    SEQUENCE OWNED BY     L   ALTER SEQUENCE public.shippings_id_seq OWNED BY public.shipping_types.idst;
          public          postgres    false    219            �            1259    16721    shippings_of_products_idsop_seq    SEQUENCE     �   CREATE SEQUENCE public.shippings_of_products_idsop_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.shippings_of_products_idsop_seq;
       public          postgres    false    232            E           0    0    shippings_of_products_idsop_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public.shippings_of_products_idsop_seq OWNED BY public.shippings_of_products.idsop;
          public          postgres    false    231            r           2604    16610    customers idc    DEFAULT     m   ALTER TABLE ONLY public.customers ALTER COLUMN idc SET DEFAULT nextval('public.customers_id_seq'::regclass);
 <   ALTER TABLE public.customers ALTER COLUMN idc DROP DEFAULT;
       public          postgres    false    215    216    216            w           2604    16838 #   customers_optional_attributes idcoa    DEFAULT     �   ALTER TABLE ONLY public.customers_optional_attributes ALTER COLUMN idcoa SET DEFAULT nextval('public.customers_optional_attributes_idcoa_seq'::regclass);
 R   ALTER TABLE public.customers_optional_attributes ALTER COLUMN idcoa DROP DEFAULT;
       public          postgres    false    238    239    239            u           2604    16651 
   orders ido    DEFAULT     g   ALTER TABLE ONLY public.orders ALTER COLUMN ido SET DEFAULT nextval('public.orders_id_seq'::regclass);
 9   ALTER TABLE public.orders ALTER COLUMN ido DROP DEFAULT;
       public          postgres    false    221    222    222            s           2604    16631    products idp    DEFAULT     k   ALTER TABLE ONLY public.products ALTER COLUMN idp SET DEFAULT nextval('public.products_id_seq'::regclass);
 ;   ALTER TABLE public.products ALTER COLUMN idp DROP DEFAULT;
       public          postgres    false    218    217    218            x           2604    16854 "   products_optional_attributes idpoa    DEFAULT     �   ALTER TABLE ONLY public.products_optional_attributes ALTER COLUMN idpoa SET DEFAULT nextval('public.products_optional_attributes_idpoa_seq'::regclass);
 Q   ALTER TABLE public.products_optional_attributes ALTER COLUMN idpoa DROP DEFAULT;
       public          postgres    false    241    240    241            t           2604    16644    shipping_types idst    DEFAULT     s   ALTER TABLE ONLY public.shipping_types ALTER COLUMN idst SET DEFAULT nextval('public.shippings_id_seq'::regclass);
 B   ALTER TABLE public.shipping_types ALTER COLUMN idst DROP DEFAULT;
       public          postgres    false    219    220    220            v           2604    16725    shippings_of_products idsop    DEFAULT     �   ALTER TABLE ONLY public.shippings_of_products ALTER COLUMN idsop SET DEFAULT nextval('public.shippings_of_products_idsop_seq'::regclass);
 J   ALTER TABLE public.shippings_of_products ALTER COLUMN idsop DROP DEFAULT;
       public          postgres    false    231    232    232            ,          0    16607 	   customers 
   TABLE DATA           G   COPY public.customers (idc, name, address, phone, contact) FROM stdin;
    public          postgres    false    216   �{       6          0    16835    customers_optional_attributes 
   TABLE DATA           h   COPY public.customers_optional_attributes (idcoa, id_customer, attr_name, relevance, value) FROM stdin;
    public          postgres    false    239   /~       2          0    16648    orders 
   TABLE DATA           [   COPY public.orders (ido, id_customer, id_product, id_shipping, quantity, date) FROM stdin;
    public          postgres    false    222          .          0    16628    products 
   TABLE DATA           ;   COPY public.products (idp, price, description) FROM stdin;
    public          postgres    false    218   р       8          0    16851    products_optional_attributes 
   TABLE DATA           f   COPY public.products_optional_attributes (idpoa, id_product, attr_name, relevance, value) FROM stdin;
    public          postgres    false    241   ˂       0          0    16641    shipping_types 
   TABLE DATA           5   COPY public.shipping_types (idst, price) FROM stdin;
    public          postgres    false    220   %�       4          0    16722    shippings_of_products 
   TABLE DATA           O   COPY public.shippings_of_products (idsop, id_product, id_shipping) FROM stdin;
    public          postgres    false    232   S�       F           0    0    customers_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('public.customers_id_seq', 10, true);
          public          postgres    false    215            G           0    0 '   customers_optional_attributes_idcoa_seq    SEQUENCE SET     V   SELECT pg_catalog.setval('public.customers_optional_attributes_idcoa_seq', 40, true);
          public          postgres    false    238            H           0    0    orders_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('public.orders_id_seq', 54, true);
          public          postgres    false    221            I           0    0    products_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.products_id_seq', 25, true);
          public          postgres    false    217            J           0    0 &   products_optional_attributes_idpoa_seq    SEQUENCE SET     U   SELECT pg_catalog.setval('public.products_optional_attributes_idpoa_seq', 75, true);
          public          postgres    false    240            K           0    0    shippings_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.shippings_id_seq', 3, true);
          public          postgres    false    219            L           0    0    shippings_of_products_idsop_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public.shippings_of_products_idsop_seq', 46, true);
          public          postgres    false    231            �           2606    16842 @   customers_optional_attributes customers_optional_attributes_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.customers_optional_attributes
    ADD CONSTRAINT customers_optional_attributes_pkey PRIMARY KEY (idcoa);
 j   ALTER TABLE ONLY public.customers_optional_attributes DROP CONSTRAINT customers_optional_attributes_pkey;
       public            postgres    false    239            z           2606    16612    customers customers_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (idc);
 B   ALTER TABLE ONLY public.customers DROP CONSTRAINT customers_pkey;
       public            postgres    false    216            �           2606    16653    orders orders_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (ido);
 <   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_pkey;
       public            postgres    false    222            �           2606    16858 >   products_optional_attributes products_optional_attributes_pkey 
   CONSTRAINT        ALTER TABLE ONLY public.products_optional_attributes
    ADD CONSTRAINT products_optional_attributes_pkey PRIMARY KEY (idpoa);
 h   ALTER TABLE ONLY public.products_optional_attributes DROP CONSTRAINT products_optional_attributes_pkey;
       public            postgres    false    241            |           2606    16635    products products_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY public.products
    ADD CONSTRAINT products_pkey PRIMARY KEY (idp);
 @   ALTER TABLE ONLY public.products DROP CONSTRAINT products_pkey;
       public            postgres    false    218            �           2606    16727 0   shippings_of_products shippings_of_products_pkey 
   CONSTRAINT     q   ALTER TABLE ONLY public.shippings_of_products
    ADD CONSTRAINT shippings_of_products_pkey PRIMARY KEY (idsop);
 Z   ALTER TABLE ONLY public.shippings_of_products DROP CONSTRAINT shippings_of_products_pkey;
       public            postgres    false    232            ~           2606    16646    shipping_types shippings_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.shipping_types
    ADD CONSTRAINT shippings_pkey PRIMARY KEY (idst);
 G   ALTER TABLE ONLY public.shipping_types DROP CONSTRAINT shippings_pkey;
       public            postgres    false    220            %           2618    16720 (   products_price_morethan_avgprice _RETURN    RULE     e  CREATE OR REPLACE VIEW public.products_price_morethan_avgprice AS
 SELECT idp,
    price,
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
    NULL::character varying(50) AS description,
    NULL::numeric AS avg;
       public          postgres    false    4732    218    218    218    230            &           2618    16746 )   customers_leftjoin_total_quantity _RETURN    RULE     f  CREATE OR REPLACE VIEW public.customers_leftjoin_total_quantity AS
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
       public          postgres    false    222    216    216    216    216    216    4730    222    233            �           2620    16771    orders insert    TRIGGER     n   CREATE TRIGGER insert BEFORE INSERT ON public.orders FOR EACH ROW EXECUTE FUNCTION public.insert_in_orders();
 &   DROP TRIGGER insert ON public.orders;
       public          postgres    false    222    242            �           2606    16843 L   customers_optional_attributes customers_optional_attributes_id_customer_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.customers_optional_attributes
    ADD CONSTRAINT customers_optional_attributes_id_customer_fkey FOREIGN KEY (id_customer) REFERENCES public.customers(idc);
 v   ALTER TABLE ONLY public.customers_optional_attributes DROP CONSTRAINT customers_optional_attributes_id_customer_fkey;
       public          postgres    false    216    4730    239            �           2606    16654    orders orders_id_customer_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_id_customer_fkey FOREIGN KEY (id_customer) REFERENCES public.customers(idc) NOT VALID;
 H   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_id_customer_fkey;
       public          postgres    false    222    4730    216            �           2606    16659    orders orders_id_product_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_id_product_fkey FOREIGN KEY (id_product) REFERENCES public.products(idp) NOT VALID;
 G   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_id_product_fkey;
       public          postgres    false    222    4732    218            �           2606    16664    orders orders_id_shipping_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_id_shipping_fkey FOREIGN KEY (id_shipping) REFERENCES public.shipping_types(idst) NOT VALID;
 H   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_id_shipping_fkey;
       public          postgres    false    222    4734    220            �           2606    16859 I   products_optional_attributes products_optional_attributes_id_product_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.products_optional_attributes
    ADD CONSTRAINT products_optional_attributes_id_product_fkey FOREIGN KEY (id_product) REFERENCES public.products(idp);
 s   ALTER TABLE ONLY public.products_optional_attributes DROP CONSTRAINT products_optional_attributes_id_product_fkey;
       public          postgres    false    4732    241    218            �           2606    16728 ;   shippings_of_products shippings_of_products_id_product_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.shippings_of_products
    ADD CONSTRAINT shippings_of_products_id_product_fkey FOREIGN KEY (id_product) REFERENCES public.products(idp) NOT VALID;
 e   ALTER TABLE ONLY public.shippings_of_products DROP CONSTRAINT shippings_of_products_id_product_fkey;
       public          postgres    false    218    4732    232            �           2606    16733 <   shippings_of_products shippings_of_products_id_shipping_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.shippings_of_products
    ADD CONSTRAINT shippings_of_products_id_shipping_fkey FOREIGN KEY (id_shipping) REFERENCES public.shipping_types(idst) NOT VALID;
 f   ALTER TABLE ONLY public.shippings_of_products DROP CONSTRAINT shippings_of_products_id_shipping_fkey;
       public          postgres    false    220    4734    232            ,   (  x�E�MO�0��ί�c�ʱ�aK�`!,,E�e/n2j��6r�vïg�"�-��'���dl��Kx�-0���18��RC=y7�Kodת�E��+��"U�����:��~J����wK�M��q�&qbY&2�p�C����h��`��WPq��BkV��E�F���H���`w#~.���i&?x��0�]�O^L؟�Į�l��̊�B
���ԣC�=R`�)m�^����qh�=^���[
�T^I����Lf�%E��_�U�l�l@X����IA��d��ې>Vi��"g΅M�?f)Ȩ"�J�T���@Q�z��cLJv�a��xXһ�7���Of�YU�/bk<��l��BR�T+.�*�]Xm�7I�n͸��)�~j��.��M?tL�s����h�E�"�4oY�BɌ��x�����f�(v�[L����0P�ܙ���� 1R�eFYVi^�=ǎ�{�~��c�)�w�Y����4�v��`laN�h9�JK��.����1�8m1����i��Y��qp��{qQ���J%�95d��Ǿ�0v��I�|��f      6   �   x�e�;�@E��Y�x��`T��)$��PF���Oc39z��ۼާmY�A����en����y�O���BB1JFTJ�p(�|���0Ρ*Ǳ�r�B/$+ET-%)M�{� Y��*�G)�ĎR'1#�=����&Eʽ����Q�T�4�R�$?"��;T%y�rH�S���d����$�I�p�n�H�V���r��v?��^���a� O�ɫ      2   �  x�USٍ�0��z��:⣗���!�<�� �ϠxHZz1�u/V-��u��E��,�	ޔI���_�$�x��񐻌b��l�����﫪t�P<�D�20�*_���e�����J�/9��U4A����p�ZAc[���z<�O:m������p��Kf��0m[=�sj��� +� ݞ<˗��t�,#=23-�Q����c�ml�����̃~�e��A�)kt�͚�j��a:��a{ףֳx�O��he
Y�p���:�"!�3O[n�֖z�Pŝsi�X4��r�g�-�^z�;S�\uAu�̳D����޶�.>�Nt���^�Q��fHp��3z��ʐ)���0�a��5�pc��w��>�5����ŏ�W�ِ��J�q����c�k���\��$�䮹�y�z6h\�;�G���ܝ��D��f�      .   �  x�]�Mn�0���S� !R��Z�ݠuk�A�醐�!�H��s�������7�IBU����	��7V�ҢP��!o��oM�O�����;��J�E�ጆZ1Roo�	��j�KQ���aD���O���v#�J_Fր���`��w�)�	�i(sQj�R�'��3�5�u�2Y@%�����1ݛI��p��RK~��� UR٣s׀8�3bϔ]%�?��cb���"S$�EV�wߏ��GG�3��n��@Bp�3��S�5Α"��"�`�����g5Uk8��K�;�-?*�T)��~}K:����c��]����d���i%�M7�(*x�!T��;�9��!��:i/�3V�X�d��
R&���_�u�T��4���wa��B�1Y��DU�y��9i#^6|��1�C�EE+/�ܒ-ZLJ�ZJ�
��PHwYR�=HW�V��`��ގH��j2�p��?�eR��D^���ta0�`������      8   J  x�m�;NA���0h{fz��Nl,�8=Ur��j���O۵��r��8>�n���<��q�h_���~jR�'��z������)��$&��S�.-UDo� 8T�2j��C]zF1���В�P�=*�p�RdfTj���:b@��)��Z��՝�tUE���kp�Ź&�7Q�5�����˨�5����{�y4e���p０�X�3�p�<�6X��,���y'��zg�r:ý�T���X�ý�Z��7X��R�^l���zg9]W)y/��WY��+$�kp�Ź!%�O���{���y/CY���9�;�e4����=���a۶?�h;      0      x�3�4�30�2�44 �ƜF`~� =�      4   �   x���1�PL�@�>�����*֒1�PQ��T��9O�\T厉�C�|cq��9��Uq�� ��ks��� 7��5��1�]���n_&>߷}�v��QN��D3ϩ�y$�9����F2�c��#��6�4;�hr]�]�2��`T�L�1�W���as��d��~.W     