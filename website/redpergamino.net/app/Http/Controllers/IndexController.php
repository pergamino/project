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
}
