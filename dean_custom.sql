PGDMP  %            
        |            dean    16.3    16.3 #    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16984    dean    DATABASE     x   CREATE DATABASE dean WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Russian_Russia.1251';
    DROP DATABASE dean;
                postgres    false            �            1259    16986    courses    TABLE     �   CREATE TABLE public.courses (
    idc bigint NOT NULL,
    cname character varying(45) NOT NULL,
    creduts numeric(4,0) NOT NULL
);
    DROP TABLE public.courses;
       public         heap    postgres    false            �            1259    16985    courses_idc_seq    SEQUENCE     x   CREATE SEQUENCE public.courses_idc_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.courses_idc_seq;
       public          postgres    false    216            �           0    0    courses_idc_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE public.courses_idc_seq OWNED BY public.courses.idc;
          public          postgres    false    215            �            1259    17006    lectors    TABLE     �   CREATE TABLE public.lectors (
    idl bigint NOT NULL,
    fn character varying(45) NOT NULL,
    ln character varying(45) NOT NULL,
    iddep bigint NOT NULL,
    salary numeric(12,2) NOT NULL
);
    DROP TABLE public.lectors;
       public         heap    postgres    false            �            1259    17039    marks    TABLE     �   CREATE TABLE public.marks (
    idm bigint NOT NULL,
    idst bigint NOT NULL,
    idcr bigint NOT NULL,
    dex date NOT NULL,
    exmr bigint NOT NULL,
    mark bigint NOT NULL
);
    DROP TABLE public.marks;
       public         heap    postgres    false            �            1259    17038    marks_idm_seq    SEQUENCE     v   CREATE SEQUENCE public.marks_idm_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.marks_idm_seq;
       public          postgres    false    220            �           0    0    marks_idm_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.marks_idm_seq OWNED BY public.marks.idm;
          public          postgres    false    219            �            1259    17001    students    TABLE     �   CREATE TABLE public.students (
    ids bigint NOT NULL,
    fn character varying(45) NOT NULL,
    ln character varying(45) NOT NULL,
    dob date NOT NULL,
    mentor bigint NOT NULL
);
    DROP TABLE public.students;
       public         heap    postgres    false            �            1259    17060    student_with_mentor    VIEW       CREATE VIEW public.student_with_mentor AS
 SELECT students.ids,
    students.fn,
    students.ln,
    students.dob,
    students.mentor,
    lectors.fn AS lfn,
    lectors.ln AS lln
   FROM (public.students
     LEFT JOIN public.lectors ON ((students.mentor = lectors.idl)));
 &   DROP VIEW public.student_with_mentor;
       public          postgres    false    218    217    218    218    217    217    217    217            �            1259    17064    students_avg_mark    VIEW     �   CREATE VIEW public.students_avg_mark AS
SELECT
    NULL::bigint AS ids,
    NULL::character varying(45) AS fn,
    NULL::character varying(45) AS ln,
    NULL::date AS dob,
    NULL::bigint AS mentor,
    NULL::numeric AS avg;
 $   DROP VIEW public.students_avg_mark;
       public          postgres    false            �            1259    17069    students_avg_mark_by_courses    VIEW     T  CREATE VIEW public.students_avg_mark_by_courses AS
SELECT
    NULL::bigint AS ids,
    NULL::character varying(45) AS fn,
    NULL::character varying(45) AS ln,
    NULL::date AS dob,
    NULL::bigint AS mentor,
    NULL::bigint AS idc,
    NULL::character varying(45) AS cname,
    NULL::numeric(4,0) AS creduts,
    NULL::numeric AS avg;
 /   DROP VIEW public.students_avg_mark_by_courses;
       public          postgres    false            �            1259    17074    students_count_of_marks    VIEW     �   CREATE VIEW public.students_count_of_marks AS
SELECT
    NULL::bigint AS ids,
    NULL::character varying(45) AS fn,
    NULL::character varying(45) AS ln,
    NULL::date AS dob,
    NULL::bigint AS mentor,
    NULL::bigint AS count;
 *   DROP VIEW public.students_count_of_marks;
       public          postgres    false            7           2604    16989    courses idc    DEFAULT     j   ALTER TABLE ONLY public.courses ALTER COLUMN idc SET DEFAULT nextval('public.courses_idc_seq'::regclass);
 :   ALTER TABLE public.courses ALTER COLUMN idc DROP DEFAULT;
       public          postgres    false    215    216    216            8           2604    17042 	   marks idm    DEFAULT     f   ALTER TABLE ONLY public.marks ALTER COLUMN idm SET DEFAULT nextval('public.marks_idm_seq'::regclass);
 8   ALTER TABLE public.marks ALTER COLUMN idm DROP DEFAULT;
       public          postgres    false    219    220    220            �          0    16986    courses 
   TABLE DATA                 public          postgres    false    216   l.       �          0    17006    lectors 
   TABLE DATA                 public          postgres    false    218   /       �          0    17039    marks 
   TABLE DATA                 public          postgres    false    220   �/       �          0    17001    students 
   TABLE DATA                 public          postgres    false    217   h0       �           0    0    courses_idc_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.courses_idc_seq', 5, true);
          public          postgres    false    215            �           0    0    marks_idm_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.marks_idm_seq', 5, true);
          public          postgres    false    219            :           2606    16991    courses courses_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.courses
    ADD CONSTRAINT courses_pkey PRIMARY KEY (idc);
 >   ALTER TABLE ONLY public.courses DROP CONSTRAINT courses_pkey;
       public            postgres    false    216            >           2606    17012    lectors lectors_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.lectors
    ADD CONSTRAINT lectors_pkey PRIMARY KEY (idl);
 >   ALTER TABLE ONLY public.lectors DROP CONSTRAINT lectors_pkey;
       public            postgres    false    218            @           2606    17044    marks marks_pkey 
   CONSTRAINT     O   ALTER TABLE ONLY public.marks
    ADD CONSTRAINT marks_pkey PRIMARY KEY (idm);
 :   ALTER TABLE ONLY public.marks DROP CONSTRAINT marks_pkey;
       public            postgres    false    220            <           2606    17005    students studs_pkey 
   CONSTRAINT     R   ALTER TABLE ONLY public.students
    ADD CONSTRAINT studs_pkey PRIMARY KEY (ids);
 =   ALTER TABLE ONLY public.students DROP CONSTRAINT studs_pkey;
       public            postgres    false    217            �           2618    17067    students_avg_mark _RETURN    RULE     4  CREATE OR REPLACE VIEW public.students_avg_mark AS
 SELECT students.ids,
    students.fn,
    students.ln,
    students.dob,
    students.mentor,
    avg(marks.mark) AS avg
   FROM (public.students
     LEFT JOIN public.marks ON (((students.ids = marks.idst) AND (marks.mark > 2))))
  GROUP BY students.ids;
 �   CREATE OR REPLACE VIEW public.students_avg_mark AS
SELECT
    NULL::bigint AS ids,
    NULL::character varying(45) AS fn,
    NULL::character varying(45) AS ln,
    NULL::date AS dob,
    NULL::bigint AS mentor,
    NULL::numeric AS avg;
       public          postgres    false    220    217    217    217    217    217    4668    220    222            �           2618    17072 $   students_avg_mark_by_courses _RETURN    RULE     �  CREATE OR REPLACE VIEW public.students_avg_mark_by_courses AS
 SELECT students.ids,
    students.fn,
    students.ln,
    students.dob,
    students.mentor,
    courses.idc,
    courses.cname,
    courses.creduts,
    avg(marks.mark) AS avg
   FROM ((public.students
     LEFT JOIN public.marks ON ((students.ids = marks.idst)))
     LEFT JOIN public.courses ON ((courses.idc = marks.idcr)))
  GROUP BY students.ids, courses.idc;
 _  CREATE OR REPLACE VIEW public.students_avg_mark_by_courses AS
SELECT
    NULL::bigint AS ids,
    NULL::character varying(45) AS fn,
    NULL::character varying(45) AS ln,
    NULL::date AS dob,
    NULL::bigint AS mentor,
    NULL::bigint AS idc,
    NULL::character varying(45) AS cname,
    NULL::numeric(4,0) AS creduts,
    NULL::numeric AS avg;
       public          postgres    false    220    220    220    4668    217    217    217    217    217    4666    216    216    216    223            �           2618    17077    students_count_of_marks _RETURN    RULE     $  CREATE OR REPLACE VIEW public.students_count_of_marks AS
 SELECT students.ids,
    students.fn,
    students.ln,
    students.dob,
    students.mentor,
    count(marks.*) AS count
   FROM (public.students
     LEFT JOIN public.marks ON ((students.ids = marks.idst)))
  GROUP BY students.ids;
 �   CREATE OR REPLACE VIEW public.students_count_of_marks AS
SELECT
    NULL::bigint AS ids,
    NULL::character varying(45) AS fn,
    NULL::character varying(45) AS ln,
    NULL::date AS dob,
    NULL::bigint AS mentor,
    NULL::bigint AS count;
       public          postgres    false    217    217    217    4668    217    217    220    224            B           2606    17055    marks marks_exmr_fkey    FK CONSTRAINT     ~   ALTER TABLE ONLY public.marks
    ADD CONSTRAINT marks_exmr_fkey FOREIGN KEY (exmr) REFERENCES public.lectors(idl) NOT VALID;
 ?   ALTER TABLE ONLY public.marks DROP CONSTRAINT marks_exmr_fkey;
       public          postgres    false    4670    220    218            C           2606    17050    marks marks_idcr_fkey    FK CONSTRAINT     ~   ALTER TABLE ONLY public.marks
    ADD CONSTRAINT marks_idcr_fkey FOREIGN KEY (idcr) REFERENCES public.courses(idc) NOT VALID;
 ?   ALTER TABLE ONLY public.marks DROP CONSTRAINT marks_idcr_fkey;
       public          postgres    false    216    220    4666            D           2606    17045    marks marks_idst_fkey    FK CONSTRAINT     u   ALTER TABLE ONLY public.marks
    ADD CONSTRAINT marks_idst_fkey FOREIGN KEY (idst) REFERENCES public.students(ids);
 ?   ALTER TABLE ONLY public.marks DROP CONSTRAINT marks_idst_fkey;
       public          postgres    false    217    220    4668            A           2606    17033    students studs_mentor_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.students
    ADD CONSTRAINT studs_mentor_fkey FOREIGN KEY (mentor) REFERENCES public.lectors(idl) NOT VALID;
 D   ALTER TABLE ONLY public.students DROP CONSTRAINT studs_mentor_fkey;
       public          postgres    false    218    4670    217            �   �   x���A�0��=���h &��\eA�H,��fl�@K�m���� ��/�nXu�n�+�~�r�ɢ�Gy�W�Y�B��ӽzB��P��q
���yH�R�ƚY���"�c�@KFP?M��b��]�rr����s�	��}������;�;E54`�      �   �   x���1�0ཿ"[DR��8u�,mtOC���'IZ��{������>ǫ��	�+q!���F��V�'���5Y���+Bs�h(���>h�c�k�flyJ�_���t`��X	�T�}g�x��m�Op;N�2�8I�y�.���
�>@�s�yL���A���!*��1Ä�X�| H�k$      �   |   x���v
Q���W((M��L��M,�.Vs�	uV�0�Q0430 Q@�nd`h�k`�kh�100�Q0Ҵ��$d��#�Ƙc�1�5FH�@�1%��kpcJ�1�c�qx
h��.. t�T�      �   �   x��ν�0����&���"'Q�^����h}~[�d:��=_Nq�U��SsFow�]��{mt���FK�k�h:��Q�	�-`�``����Gş��\q��A�H���G4I1�1M磱���?�4!y+��4�dB�����<up����|�0���f��5WN� y��Q�a��&��/�dp�     