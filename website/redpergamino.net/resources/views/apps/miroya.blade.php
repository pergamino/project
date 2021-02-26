@include('shared.head')
@include('shared.header')
<main id="main">
    <!-- ======= Features Section ======= -->
    <!-- ======= MODELOS Section ======= -->
    <section  class="portfolio">
        <div class="container">

            <div class="section-title mt-5" data-aos="fade-up">
            <div>
                <img src="..." class="img-thumbnail" alt="...">
                <h2>¿Qué es MiRoya?</h2>
            </div>
            <p class="text-center">
                El Modelo "MiRoya" es un Sistema Multi-Agente (SMA), basado en la plataforma CORMAS.
            </p>
            <p class="text-left mt-2">
                El objetivo es tener un simulador interactivo para promover debates sobre los aspectos socio-económicos de la producción de café en un contexto de crisis de la roya. Facilitar la armonización de las alertas y de las acciones a nivel institucional.
            </p>
            </div>
        </div>
    </section>
    
    <section class="pricing section-bg">
        <div class="container" data-aos="fade-up">
            <div class="row" >
                <div class="col-12">
                    <p class="h3">Objetivo del Modelo</p>
                    <p class="my-2">
                        El primer objetivo del modelo MiRoya es de integrar y probar informaciones científicas y de
                        expertos en un modelo de simulación, para:
                    </p>
                    <ul class="text-left mt-5 ml-5">
                        <li>
                            <i class="bx bx-circle"></i>
                            Comprender los mecanismos biofísicos                       
                        </li>
                        <li>
                            <i class="bx bx-circle"></i>
                            Jerarquizar los parámetros que influyen en las epidemias de roya
                      
                        </li>
                        <li>
                            <i class="bx bx-circle"></i>
                            Compartir conocimientos                      
                        </li>
                        <li>
                            <i class="bx bx-circle"></i>
                            Probar hipótesis                      
                        </li>
                        <li>
                            <i class="bx bx-circle"></i>
                            Probar diferentes medios de control de la roya                     
                        </li>
                        <li>
                            <i class="bx bx-circle"></i>
                            Consolidar una Red Regional de Gestión de Riesgos en Café (RR-GRC)
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </section>
    <section class="pricing">
        <div class="container" data-aos="fade-up">
            <div class="row" >
                <div class="col-12">
                    <p class="my-2">
                    El modelo también sirve como simulador interactivo multijugador (Simulacro) para armonizar
                    los niveles de alerta. Para apoyar la organización de juegos serios, este simulador busca
                    promover debates sobre los aspectos socio-económicos de la producción de café en un
                    contexto de crise de la roya.
                    </p>
                </div>
            </div>
            <div class="row" >
                <div class="col-12">
                    <img src="" alt="">
                </div>
            </div>
            <div class="row" >
                <div class="col-12">
                    <p>
                        Basado en un modelo del ciclo de vida de la roya y de los cafetos, este modelo simula la
                        producción de café según las condiciones climáticas, las enfermedades debidas a la roya y
                        los tratamientos aplicados por los agentes productores.
                    </p>
                    <p class="mt-2">
                        Dirigido a técnicos y gerentes de institutos cafeteros, el objetivo de este juego es doble: 1°)
                        Facilitar la armonización de las alertas y de las acciones al nivel institucional; 2°) Generar
                        recomendaciones efectivas y oportunas para los pequeños productores con recursos
                        financieros limitados.
                    </p>
                    <p class="mt-2">
                        Al señalar la importancia de la comunicación entre los países, este modelo también tiene
                        Tiene como objetivo estructurar una red regional de institutos meteorológicos y agronómicos. A fin de encontrar estrategias de prevención y control adaptables, también es necesario que los
                        países intercambien información sobre los niveles de gravedad de la roya.
                    </p>
                </div>
            </div>
        </div>
    </section>
    <section class="pricing section-bg">
        <div class="container" data-aos="fade-up">
            <div class="row" >
                <div class="col-12">
                    <h3 class="my-2">
                    Descripción del modelo conceptual

                    </h3>
                </div>
            </div>
            <div class="row">
                <div class="col-12">
                    <img src="" alt="">
                </div>
            </div>
            <div class="row" >
                <div class="col-12 pl-5">
                    <p>
                        MiRoya es basado en un modelo multi-agentes (ABM en inglés) que permita simular la 
                        dinámica de la roya y sus impactos en término de incidencia, caída de hojas y producción
                        de café.
                    </p>
                    <p class="mt-2">
                        MiRoya permita comprender y evaluar el funcionamiento de la roya del café y los
                        parámetros que influyen en la propagación de las epidemias. El modelo busca probar la
                        efectividad de las prácticas que los caficultores pueden implementar.
                    </p>
                    <p class="mt-2">
                        Esquemáticamente, el modelo representa fincas de café compuestas por parcelas de una
                        hectárea. Dependiendo del clima y la época del año, crecen los cafetos y los hongos de la
                        roya. La siguiente figura muestra este patrón:
                    </p>
                    <img src="" alt="">
                </div>
            </div>
        </div>
    </section>
</main><!-- End #main -->
<script async src="https://www.googletagmanager.com/gtag/js?id=G-THJ0900S2G"></script>
<script src="{{ URL::asset('js/gtag.js') }}" ></script>
@include('shared.footer')
