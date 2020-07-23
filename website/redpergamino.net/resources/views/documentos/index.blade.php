 <!-- ======= TESIS Section ======= -->
 <section  class="portfolio">
      <div class="container">

        <!-- <div class="section-title" data-aos="fade-up"> -->
        <div class="section-title">
          <h2>Tesis de estudiantes</h2>
        </div>

        <!-- <div class="row portfolio-container" data-aos="fade-up" data-aos-delay="200"> -->
        <div class="row portfolio-container">
            
              @foreach($tesis_main as $tesis)
          <div class="col-lg-4 col-md-2 portfolio-item filter-app">
            <div class="portfolio-wrap">
              <img src="{{$tesis['thumb']}}" class="img-fluid" alt="">
              <div class="portfolio-info">
                <h4>{{$tesis['title']}}</h4>
                <p>{{$tesis['description']}}</p>
              </div>
              <div class="portfolio-links">
                <a href="{{$tesis['url']}}" target="_blank" title="{{$tesis['title']}}"><i class="bx bx-link"></i></a>
                
              </div>
              <h4>{{$tesis['title']}}</h4>
                <p>{{$tesis['description']}}</p>
            </div>
          </div>
        @endforeach 
        </div>

      </div>
    </section>
<!-- End TESIS Section -->

<!-- ======= CONGRESOS Section ======= -->
 <section  class="portfolio">
      <div class="container">

        <div class="section-title" >
          <h2>Presentaciones en congresos</h2>
        </div>

        <div class="row portfolio-container">
            
              @foreach($congresos_main as $tesis)
          <div class="col-lg-4 col-md-2 portfolio-item filter-app">
            <div class="portfolio-wrap">
              <img src="{{$tesis['thumb']}}" class="img-fluid" alt="">
              <div class="portfolio-info">
                <h4>{{$tesis['title']}}</h4>
                <p>{{$tesis['description']}}</p>
              </div>
              <div class="portfolio-links">
                <a href="{{$tesis['url']}}" target="_blank" title="{{$tesis['title']}}"><i class="bx bx-link"></i></a>
                
              </div>
              <h4>{{$tesis['title']}}</h4>
                <p>{{$tesis['description']}}</p>
            </div>
          </div>
        @endforeach 
        </div>

      </div>
    </section>
<!-- End TESIS Section -->

<!-- ======= CIENTIFIC Section ======= -->
<section  class="portfolio">
      <div class="container">

        <div class="section-title">
          <h2>Documentos técnicos y científicos</h2>
        </div>

        <div class="row portfolio-container">
            
              @foreach($cientific_main as $tesis)
          <div class="col-lg-4 col-md-2 portfolio-item filter-app">
            <div class="portfolio-wrap">
              <img src="{{$tesis['thumb']}}" class="img-fluid" alt="">
              <div class="portfolio-info">
                <h4>{{$tesis['title']}}</h4>
                <p>{{$tesis['description']}}</p>
              </div>
              <div class="portfolio-links">
                <a href="{{$tesis['url']}}" target="_blank" title="{{$tesis['title']}}"><i class="bx bx-link"></i></a>
                
              </div>
              <h4>{{$tesis['title']}}</h4>
                <p>{{$tesis['description']}}</p>
            </div>
          </div>
        @endforeach 
        </div>

      </div>
    </section>
<!-- End CIENTIFIC Section -->