<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Collection;


class IndexController extends Controller
{   
    /*English */
    public function index(){
        return view('index');
    }
    public function pergamino(){
        return view('welcome');
    }

    public function plataforma(){
        return view('plataforma');
    }

    public function privacidad(){
        return view('pergamino.privacidad');
    }

    public function modelos(){
        return view('modelos');
    }

    public function documentos(){
        $tesis =[[
            'title'=>'Master Edwin Treminio',
            'description'=>'Estimación de la eficiencia de métodos territoriales de muestreo de la roya', 
            'url'=>'https://drive.google.com/file/d/1172P_7NfahEP_3r3rKta-CQCSm9FD53e/view', 
            'thumb'=>'https://drive.google.com/thumbnail?id=1172P_7NfahEP_3r3rKta-CQCSm9FD53e&sz=w350-h220-p-k-nu'],
            [
            'title'=>'Master Michelle Cevallos',
            'description'=>'Creando las bases para un SAT Regional', 
            'url'=>'https://drive.google.com/file/d/1172P_7NfahEP_3r3rKta-CQCSm9FD53e/view', 
            'thumb'=>'https://drive.google.com/thumbnail?id=1rb0O8Fp0ojmwzjDJ2GSkMkFU90T5g-qW&sz=w350-h220-p-k-nu'],
            [
            'title'=>'Master Andrés Madrid Arrieta',
            'description'=>'Diseño participativo de un prototipo de herramienta digital', 
            'url'=>'https://drive.google.com/file/d/1172P_7NfahEP_3r3rKta-CQCSm9FD53e/view', 
            'thumb'=>'https://drive.google.com/thumbnail?id=1ABD3A-bVlWC6jqvv3fOhRVk1G9zc0jFU&sz=w350-h220-p-k-nu'],
            [
            'title'=>'Master Hipolito Cofré',
            'description'=>'Análisis retrospectivo de los factores ambientales y socioeconómicos influyentes en la manifestación de plagas/enfermedades', 
            'url'=>'https://drive.google.com/file/d/1I520WDTfa6T19pmqL3YdA4rn8nUbCjWk/view', 
            'thumb'=>'https://drive.google.com/thumbnail?id=1I520WDTfa6T19pmqL3YdA4rn8nUbCjWk&sz=w350-h220-p-k-nu'],
            [
            'title'=>'Master Karina Hernández Espinoza',
            'description'=>'Escenarios climáticos para eventos con impactos de roya, ojo de gallo y broca del café en Guatemala, Honduras, El Salvador y Costa Rica', 
            'url'=>'https://drive.google.com/file/d/1-gUA5g3pg0myIQRDWy4itsodo_OWVVIv/view', 
            'thumb'=>'https://drive.google.com/thumbnail?id=1-gUA5g3pg0myIQRDWy4itsodo_OWVVIv&sz=w350-h220-p-k-nu'],
            [
            'title'=>'Doctorado Isabelle Merle',
            'description'=>'Effets du microclimat sur le développement de l’épidémie de rouille orangée du caféier Arabica (Hemileia vastatrix – Coffea arabica) dans une gamme de situations de production Le 12 décembre 2019            ', 
            'url'=>'https://drive.google.com/file/d/1R84PU4cu5o8ivkU6tOrnfL3NLYurhy2C/view', 
            'thumb'=>'https://drive.google.com/thumbnail?id=1R84PU4cu5o8ivkU6tOrnfL3NLYurhy2C&sz=w350-h220-p-k-nu']
        ];
        $tesisJson=json_encode($tesis);
        $tesis_main= json_decode($tesisJson,true);

        $congresos =[[
            'title'=>'7th AGMIP Global Workshop',
            'description'=>'Identification of microclimatic variables determining emergence of a leaf disease symptoms : case of coffee leaf rust            ', 
            'url'=>'https://drive.google.com/file/d/1uJnLjk_yrt0IAV70M76CUdFl-Tuw6btr/view', 
            'thumb'=>'https://drive.google.com/thumbnail?id=1uJnLjk_yrt0IAV70M76CUdFl-Tuw6btr&sz=w350-h220-p-k-nu'],
            [
            'title'=>'7th AGMIP Global Workshop',
            'description'=>'Towards a Central American early warning network for the prevention of coffee rust epidemics and the resulting socio-economic crises.             ', 
            'url'=>'https://drive.google.com/file/d/17-mTJ_Pdk15XhX8QhXKZpplMa8vc-xu5/view', 
            'thumb'=>'https://drive.google.com/thumbnail?id=17-mTJ_Pdk15XhX8QhXKZpplMa8vc-xu5&sz=w350-h220-p-k-nu'],
            [
            'title'=>'4th Word Congress on Agroforestry',
            'description'=>'Estimating microclimate on full sun measures to forecast coffee rust development            ', 
            'url'=>'https://drive.google.com/file/d/1K7__rClrV9cgxhqJ_2kmAP4f-iFC542g/view', 
            'thumb'=>'https://drive.google.com/thumbnail?id=1K7__rClrV9cgxhqJ_2kmAP4f-iFC542g&sz=w350-h220-p-k-nu'],
            [
            'title'=>'Bommel et al. Conferencia « Jeux et Enjeux',
            'description'=>'MiRoya, un jeu de simulation pour lutter contre la rouille du café en Amérique Centrale             ', 
            'url'=>'https://drive.google.com/file/d/1Zka948aUgJJ9ldQlO0-urBd1OEoZbLqF/view', 
            'thumb'=>'https://drive.google.com/thumbnail?id=1Zka948aUgJJ9ldQlO0-urBd1OEoZbLqF&sz=w350-h220-p-k-nu'],
            [
            'title'=>'Motisi et al. Simposio Latinoamericano de Caficultura',
            'description'=>'Modelo de pronóstico del riesgo de crecimiento de la Roya del café a escala territorial: IPSIM Roya.            ', 
            'url'=>'https://drive.google.com/file/d/1fUfWJ4whVVt65Qd4_j_klLc4mSkMcuZ6/view', 
            'thumb'=>'https://drive.google.com/thumbnail?id=1fUfWJ4whVVt65Qd4_j_klLc4mSkMcuZ6&sz=w350-h220-p-k-nu']
        ];
        $congresosJson=json_encode($congresos);
        $congresos_main= json_decode($congresosJson,true);

        $cientific =[[
            'title'=>'PROCAGICA',
            'description'=>'Plan para la optimización del monitoreo de la roya del café en las actividades de vigilancia', 
            'url'=>'https://drive.google.com/file/d/1kGAN2iYM8bGLJNxtyuxiak0wOPF_mmRU/view', 
            'thumb'=>'https://drive.google.com/thumbnail?id=1kGAN2iYM8bGLJNxtyuxiak0wOPF_mmRU&sz=w350-h220-p-k-nu'],
            [
            'title'=>'CIRAD, Marzo de 2019',
            'description'=>'Ajustando los umbrales de alerta de la roya del café', 
            'url'=>'https://drive.google.com/file/d/1gwHfd4h19boJd8Y67C4tIgqcMCPz8dO1/view', 
            'thumb'=>'https://drive.google.com/thumbnail?id=1gwHfd4h19boJd8Y67C4tIgqcMCPz8dO1&sz=w350-h220-p-k-nu'],
            [
            'title'=>'Avelino et al. Septiembre 2019',
            'description'=>'Guía de Vigilancia  de la roya del café', 
            'url'=>'https://drive.google.com/file/d/1Jyoacv_vFco8Z8FdbVCkMNejXrNKoEHu/view', 
            'thumb'=>'https://drive.google.com/thumbnail?id=1Jyoacv_vFco8Z8FdbVCkMNejXrNKoEHu&sz=w350-h220-p-k-nu'],
            [
            'title'=>'Cofré et al., Dic. de 2018',
            'description'=>'Factores influyentes en la manifestación de plagas', 
            'url'=>'https://drive.google.com/file/d/1a9PEHGFtuownfOnu0Fb1sEOhKNc1uuUG/view', 
            'thumb'=>'https://drive.google.com/thumbnail?id=1a9PEHGFtuownfOnu0Fb1sEOhKNc1uuUG&sz=w350-h220-p-k-nu'],
            [
            'title'=>'Merle et al. 2020, Crop Protection',
            'description'=>'Forecast models of coffee leaf rust symptoms on identified microclimatic combinations', 
            'url'=>'https://drive.google.com/file/d/1XfsBNfkSnuOphG1DJbeZuvxwdzrtRuGJ/view', 
            'thumb'=>'https://drive.google.com/thumbnail?id=1XfsBNfkSnuOphG1DJbeZuvxwdzrtRuGJ&sz=w350-h220-p-k-nu'],
            [
            'title'=>'Merle et al. 2020, Phytopathology',
            'description'=>'Unraveling the Complexity of Coffee Leaf Rust Behavior and Development in Different Coffea arabica Agroecosystems', 
            'url'=>'https://drive.google.com/file/d/1nQdJx0_pPMlKAF0jfYObAAl4NlbAkTfA/view', 
            'thumb'=>'https://drive.google.com/thumbnail?id=1nQdJx0_pPMlKAF0jfYObAAl4NlbAkTfA&sz=w350-h220-p-k-nu']
        ];
        $cientificJson=json_encode($cientific);
        $cientific_main= json_decode($cientificJson,true);
        return view('documentos', compact('tesis_main','congresos_main','cientific_main'));
    }

    public function EstudiosTecnicos()
    {
        $estudios = [[
            'title' => 'Inventario de los sistemas automatizados actualmente en operación',
            'descripcion' => '',
            'url' => 'https://drive.google.com/file/d/1Z0AMyQJ66OweoF8DDUXWV5MF2f4E68m7/view',
            'thumb' => 'https://drive.google.com/thumbnail?id=1Z0AMyQJ66OweoF8DDUXWV5MF2f4E68m7&sz=w350-h220-p-k-nu'
        ],
        [
            'title' => 'Diseño de una plataforma para  los SAT Café nacionales',
            'descripcion' => '',
            'url' => 'https://drive.google.com/file/d/1hPFKU45vb6cZ3k3WnL99VFbkzVZ6hbtq/view',
            'thumb' => 'https://drive.google.com/thumbnail?id=1hPFKU45vb6cZ3k3WnL99VFbkzVZ6hbtq&sz=w350-h220-p-k-nu'
        ],
        [
            'title' => 'Estrategia de implementación del SAT Café',
            'descripcion' => '',
            'url' => 'https://drive.google.com/file/d/1T4RZUJipZUNBvSdFMLw0sH6INHOiI2np/view',
            'thumb' => 'https://drive.google.com/thumbnail?id=1T4RZUJipZUNBvSdFMLw0sH6INHOiI2np&sz=w350-h220-p-k-nu'
        ],
        [
            'title' => 'Curso Taller regional en gestion de riesgos, E. Lasso',
            'descripcion' => '',
            'url' => 'https://drive.google.com/file/d/1V1WnhD3SfqE0KNq2lhLyRFu4cz03LfQO/view',
            'thumb' => 'https://drive.google.com/thumbnail?id=1V1WnhD3SfqE0KNq2lhLyRFu4cz03LfQO&sz=w350-h220-p-k-nu'
        ],
    ];
        return view('estudiostecnicos',compact('estudios'));
    }

    public function memorias(){
        $tesis =[[
            'title'=>'Memoria Nicaragua Octubre 2017',
            'description'=>'Memoria Nicaragua Octubre 2017', 
            'url'=>'https://drive.google.com/file/d/1t2eRPapnmlSEwZdKBVoWQuY38zTgX9KK/view', 
            'thumb'=>'https://drive.google.com/thumbnail?id=1t2eRPapnmlSEwZdKBVoWQuY38zTgX9KK&sz=w350-h220-p-k-nu'],
            [
            'title'=>'Memoria Nicaragua Marzo 2018',
            'description'=>'Memoria Nicaragua Marzo 2018', 
            'url'=>'https://drive.google.com/file/d/1XC5ta0y4GTLodlwh7h_5cGvkyvIkFlRW/view', 
            'thumb'=>'https://drive.google.com/thumbnail?id=1XC5ta0y4GTLodlwh7h_5cGvkyvIkFlRW&sz=w350-h220-p-k-nu'],
            [
            'title'=>'Memoria El Salvador Abril 2018',
            'description'=>'Memoria El Salvador Abril 2018', 
            'url'=>'https://drive.google.com/file/d/1CST-P8y-UenViSmIiFn4i_48GAk3m987/view', 
            'thumb'=>'https://drive.google.com/thumbnail?id=1CST-P8y-UenViSmIiFn4i_48GAk3m987&sz=w350-h220-p-k-nu'],
            [
            'title'=>'Memoria Honduras Abril 2018',
            'description'=>'Memoria Honduras Abril 2018', 
            'url'=>'https://drive.google.com/file/d/1RxtGp0AXi1Gejy3XQVNmp8t4Mbhg3D0X/view', 
            'thumb'=>'https://drive.google.com/thumbnail?id=1RxtGp0AXi1Gejy3XQVNmp8t4Mbhg3D0X&sz=w350-h220-p-k-nu'],
            [
            'title'=>'Memoria Panamá Mayo 2018',
            'description'=>'Memoria Panamá Mayo 2018', 
            'url'=>'https://drive.google.com/file/d/1dVf--KH-GdI4_AfMHJA4_4RKOy4NVscC/view', 
            'thumb'=>'https://drive.google.com/thumbnail?id=1dVf--KH-GdI4_AfMHJA4_4RKOy4NVscC&sz=w350-h220-p-k-nu'],
            [
            'title'=>'Memoria República Dominicana Junio 2018',
            'description'=>'Memoria República Dominicana Junio 2018', 
            'url'=>'https://drive.google.com/file/d/1HPGVDeNsDdrQjw4OFqHZEIMhzPAri4Hy/view', 
            'thumb'=>'https://drive.google.com/thumbnail?id=1HPGVDeNsDdrQjw4OFqHZEIMhzPAri4Hy&sz=w350-h220-p-k-nu'],
            [
            'title'=>'Memoria Guatemala Mayo 2018',
            'description'=>'Memoria Guatemala Mayo 2018', 
            'url'=>'https://drive.google.com/file/d/1m10sfXvwMZvLEjbFRQf_ekiZuwt8-xTO/view', 
            'thumb'=>'https://drive.google.com/thumbnail?id=1m10sfXvwMZvLEjbFRQf_ekiZuwt8-xTO&sz=w350-h220-p-k-nu'],
            [
            'title'=>'Memoria Costa Rica Agosto 2018',
            'description'=>'Memoria Costa Rica Agosto 2018', 
            'url'=>'https://drive.google.com/file/d/16EuudnYbMnVfHNpRe0cXBARfttNKhpJI/view', 
            'thumb'=>'https://drive.google.com/thumbnail?id=16EuudnYbMnVfHNpRe0cXBARfttNKhpJI&sz=w350-h220-p-k-nu'],
            [
            'title'=>'Memoria Honduras Octubre 2018',
            'description'=>'Memoria Honduras Octubre 2018', 
            'url'=>'https://drive.google.com/file/d/1qcduW5R8mibqYzM4-xbaEzaXTUZQqRgH/view', 
            'thumb'=>'https://drive.google.com/thumbnail?id=1qcduW5R8mibqYzM4-xbaEzaXTUZQqRgH&sz=w350-h220-p-k-nu'],
            [
            'title'=>'Memoria Guatemala Noviembre 2018',
            'description'=>'Memoria Guatemala Noviembre 2018', 
            'url'=>'https://drive.google.com/file/d/11mdFeq6Hpyzdh0WxVC-z5hpEGoCONkUx/view', 
            'thumb'=>'https://drive.google.com/thumbnail?id=11mdFeq6Hpyzdh0WxVC-z5hpEGoCONkUx&sz=w350-h220-p-k-nu'],
            [
            'title'=>'Memoria Costa Rica Octubre 2018',
            'description'=>'Memoria Costa Rica Octubre 2018', 
            'url'=>'https://drive.google.com/file/d/1G7u4dEXHMi4CBXSMnCXp1IY8bKKysAyY/view', 
            'thumb'=>'https://drive.google.com/thumbnail?id=1G7u4dEXHMi4CBXSMnCXp1IY8bKKysAyY&sz=w350-h220-p-k-nu'],
            [
            'title'=>'Memoria Honduras 2019',
            'description'=>'Memoria Honduras 2019', 
            'url'=>'https://drive.google.com/file/d/1bsvCffrBWCxwyPvqPqLc_hlsl8oqyyj6/view', 
            'thumb'=>'https://drive.google.com/thumbnail?id=1bsvCffrBWCxwyPvqPqLc_hlsl8oqyyj6&sz=w350-h220-p-k-nu'],
            [
            'title'=>'Memoria República Dominicana Mayo 2019',
            'description'=>'Memoria República Dominicana Mayo 2019', 
            'url'=>'https://drive.google.com/file/d/1ftLOWfoUXeLoVFX-bPe4F9qDwwFg-DAv/view', 
            'thumb'=>'https://drive.google.com/thumbnail?id=1ftLOWfoUXeLoVFX-bPe4F9qDwwFg-DAv&sz=w350-h220-p-k-nu'],
            [
            'title'=>'Memoria Nicaragua Junio 2019',
            'description'=>'Memoria Nicaragua Junio 2019', 
            'url'=>'https://drive.google.com/file/d/1_KPxY6Z48DIT7lZy03x6b-PCEwB328-x/view', 
            'thumb'=>'https://drive.google.com/thumbnail?id=1_KPxY6Z48DIT7lZy03x6b-PCEwB328-x&sz=w350-h220-p-k-nu'],
            [
            'title'=>'Memoria Guatemala Junio 2019',
            'description'=>'Memoria Guatemala Junio 2019', 
            'url'=>'https://drive.google.com/file/d/1IAwD-xxbSFU2nLY2GM6y0T9POe1XTZbe/view', 
            'thumb'=>'https://drive.google.com/thumbnail?id=1IAwD-xxbSFU2nLY2GM6y0T9POe1XTZbe&sz=w350-h220-p-k-nu'],
            [
            'title'=>'Memoria Nicaragua Octubre 2019',
            'description'=>'Memoria Nicaragua Octubre 2019', 
            'url'=>'https://drive.google.com/file/d/1ddxTkBP5Yvy-uQyvu0VNxZT6qs0gp0bT/view', 
            'thumb'=>'https://drive.google.com/thumbnail?id=1ddxTkBP5Yvy-uQyvu0VNxZT6qs0gp0bT&sz=w350-h220-p-k-nu']

        ];
        $tesisJson=json_encode($tesis);
        $tesis_main= json_decode($tesisJson,true);

        $galeria =[[
            'title'=>'Procagica, taller Panamá, mayo de 2018',
            'description'=>'Procagica, taller Panamá, mayo de 2018', 
            'url'=>'https://photos.google.com/share/AF1QipOM_GPbfgUz2mGkHikxH_9niKqT4aZP_jhnjGEmm6OdxycCbEtxD55uB3IAidvVTg?key=VHdsLU90aEp6ckNqSG05SnZPcVJKTnh4U3UyVlR3', 
            'thumb'=>'https://lh3.googleusercontent.com/pw/ACtC-3cehYK1uYM5bmA8f-pUkhrszB5Y4WqEoVRcanEfiAY7V98vJrW-ABPJ5SwanEqYduobnbmrG5PdSduRayCI_PhiJKYrmkZ9rowS-SF-KGor0fIK0iWZR4j10o4JjfolJ5kLPeJQ3MeOafleiTaBHWLVpg=w1234-h820-no?authuser=0'],
            [
            'title'=>'Procagica. Taller Guatemala, 22 de mayo 2018. Anacafé            ',
            'description'=>'Procagica. Taller Guatemala, 22 de mayo 2018. Anacafé            ', 
            'url'=>'https://photos.google.com/share/AF1QipPBTXV8_VfQulZu9qI7ll2-bk5bam-mDxMFNMSQLYOo7XjrRTgPLp8ggxEtIcMgMw?key=ZTM1MkdOVms2M2VkNGZFbHp5d0xicEhxSXNfb2h3', 
            'thumb'=>'https://lh3.googleusercontent.com/pw/ACtC-3fnDI2S4A--Nuux5Hh6UAV8o8TRR9zWR4Koer4j3sED0VQF2tn7c0wGkh2zOqixD8Cx4gYgS9hMsoeybXOkcvu1KHgQz-ojzYdCnOYcnU87LI9M1HND38fn9SCyE6ayQ--NyrF9IcYgzorMRVUsId4zvw=w2126-h1338-no?authuser=0'],
            [
            'title'=>'Procagica. Taller Rep. Dominicana, 19 de junio 2018.            ',
            'description'=>'Procagica. Taller Rep. Dominicana, 19 de junio 2018.            ', 
            'url'=>'https://photos.google.com/share/AF1QipODJHvAqFGhP9bX_tDqPbe1DDSHHmqmOF1VgU2Q0TXJw3YbilJNQm0_1GQVH6ZmJQ?key=QU1HSWx5Y0FnM2JhZmNScE9haEFjNERtVHI2cDd3', 
            'thumb'=>'https://lh3.googleusercontent.com/pw/ACtC-3dZeG_LSxI8LnYQiW5i8XYZzcWx9l_AJnWXL44tnFgeTN9a_SEzIQbmEr6kgL7l-W_VWud_R7nkBQ3usMARDdyxYC4YFnMpeSAButhuMDQVNorkikjh8nCiuOOdyw0UwvAsAfA6iqeXNPuSG36I51x74Q=w1784-h1338-no?authuser=0'],
            [
            'title'=>'Procagica, taller Guatemala - nov 2018            ',
            'description'=>'Procagica, taller Guatemala - nov 2018            ', 
            'url'=>'https://photos.google.com/share/AF1QipPOL2cm6WpEKSwa2y3PEfaXpnjm4mApE4Ri-wPHnFb99K5mK73GVFkjxjQ4nEzF_A?key=ZmVONGdWYVhWTnQ3UHlPSG4wNGJtdVNQSGtmcVlR', 
            'thumb'=>'https://lh3.googleusercontent.com/pw/ACtC-3cSpvHy2LwwRVVFoTiYaQ5UVA6hJKDwU_QFmSqfbiOu4KM2lcDSnU_Ua8prZ8qMOoo-VsIpR7jXNRGc73XO0WM76aX_u015PXX_bCXPaQUOGC9NVJiPr-VKvFX5zPF4dYjuY_fCS-tBVexd34bitkV7iw=w2012-h1338-no?authuser=0'],
            [
            'title'=>'Procagica, taller Honduras - Oct 2018, Tegucigalpa            ',
            'description'=>'Procagica, taller Honduras - Oct 2018, Tegucigalpa            ', 
            'url'=>'https://photos.google.com/share/AF1QipMBw5nlHzr6tclL_InLFzCrKQ7qi_UE-v4GX68khUVKPGk-jE3LH7xl0wJSMkKBrg?key=R1o5anBzcVZiYnZKTEN3WXhIUEJSa2VVZ0RPd1hR', 
            'thumb'=>'https://lh3.googleusercontent.com/pw/ACtC-3coRQsMsP34HWPA32Oo63KeFUjYGKG8XnVojwnrDCyPMRkB5DJRrEOQGhnClcqRcOktCyzU9NEv4WlTspH8wIk3ax_kgM5-Hw9jmkDLgeXr1gSW4CyJZXLjDexaBfwNYY4k0hY3_C3fB71cMrUH_E655g=w2012-h1338-no?authuser=0'],
            [
            'title'=>'procagica, taller nacional Salvador, dic 2018            ',
            'description'=>'procagica, taller nacional Salvador, dic 2018            ', 
            'url'=>'https://photos.google.com/share/AF1QipNJoq-Y1Vk3jWU6ae9j9qrMoqF-h5LsPeFnONzyZFcgHsCvU161ksRKMcZu2CjcsA?key=R1hWckYzLVdES05qQjBOSnZTZ0kwM1BmdXBIenln', 
            'thumb'=>'https://lh3.googleusercontent.com/pw/ACtC-3dsBUjOx4guahO3moztBp83CIJT5Kwq4FnnRYOOpNajxC_jtYuZqafyvoB6sfEe75WggGVgxlCeDePIR-J9H_6mr8UQ2QTduE8LHbtNczIt2UKfzFk4hrlIzIktnCL5pHEBFrGqn0lePkBX-A9FpN1FRQ=w2012-h1338-no?authuser=0'],
            [
            'title'=>'Procagica. Taller regional prevención crisis, San Salvador, 5-6 dic. 2018            ',
            'description'=>'Procagica. Taller regional prevención crisis, San Salvador, 5-6 dic. 2018            ', 
            'url'=>'https://photos.google.com/share/AF1QipPoriJ8zGRsg-57h9773nWYjlzgucjmbbQGnYzWRQd74JSXwSDssBwzUWVsguCAcw?key=Vk40ZkQweGNBblI1b0RmUzV6TnhJY0ZHZWZ6R1N3', 
            'thumb'=>'https://lh3.googleusercontent.com/pw/ACtC-3cN8zuBeAKFM0ka-Lc8WTm09NtTm3Vr3XoEk3WZAin_YODPGefU9RvyaKWzujtcLtNI_A44N3TRxXCgfIGuj__CEq1HwZ2_d9KI1zfphVQlHU9RaWwVTQtJLSpf2U8AdBQatUy5grqIoQmgBo8NHIdFtQ=w2012-h1338-no?authuser=0'],
            [
            'title'=>'Taller regional, Managua - 22-23 Octubre 2019            ',
            'description'=>'Taller regional, Managua - 22-23 Octubre 2019            ', 
            'url'=>'https://photos.google.com/share/AF1QipPDofg0YUrfR6kPVowKFmB9msgJF2AaEK4Xh-yL3B_62VtpLbjPMGSFwJnn0GH_ag?key=V09tay1iOFZsak1iX0kxZ2h2UUdvb2RYUmdBMmFB', 
            'thumb'=>'https://lh3.googleusercontent.com/pw/ACtC-3ewfONpcick5gKunak_ipEqJbmHVcf6FKbFhkLfA1-vIjkOWO8FnfLZkuMsC7TsTz1DPS0zY6wBsVy95UWJv9ydKpuavdlC_sZy-S_48QSReAD1kKaGrfmltVRTcBbID7aEmdXaLMkKodJs22ZvBUlJuw=w1280-h960-no?authuser=0']
        ];
        $galeriaJson=json_encode($galeria);
        $galeria_main= json_decode($galeriaJson,true);
       
        return view('memorias', compact('tesis_main','galeria_main'));
    }

    public function ipsim(){
        return view('apps.ipsim');
    }

    public function stadistic(){
        return view('apps.stadistic');
    }

    public function maps(){
        return view('apps.maps');
    }

    public function data(){
        return view('apps.data');
    }

    public function clrimodel(){
        return view('apps.clrimodel');
    }

    public function optimizacion(){
        return view('apps.optimizacion');
    }
    public function seroya(){
        return view('apps.seroya');
    }
    public function miroya(){
        return view('apps.miroya');
    }

    public function ml(){
        return view('apps.ml');
    }

    public function movil(){
        return view('apps.movil');
    }

}
