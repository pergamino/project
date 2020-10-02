
 
 <!-- ======= TALLERES Section ======= -->
 <section  class="portfolio">
      <div class="container">

        <div class="section-title" style="margin-top: 100px;">
          <h2 >Memorias de talleres</h2>
        </div>

        <div class="row" >
          @foreach($tesis_main as $tesis)
          <div class="checkboxes">
            <div class="doc-frame">
              <input type="checkbox" name="rGroup" value="1" id="r{{$tesis['title']}}" checked="checked"/>
              <label class="checkbox-skin" for="r{{$tesis['title']}}">
                <a href="{{$tesis['url']}}" target="_blank">
                <div class="doc-preview" style="background-image: url('{{$tesis['thumb']}} '); background-size: contain;background-position: center center;">
               
                </div>
                </a>
              <label class="doc-name"><i class="material-icons">subject</i>{{\Illuminate\Support\Str::limit($tesis['title'],25, $end='...')}}</label>
              </label>
            </div>
          </div>
          @endforeach 
        </div>
      </div>
    </section>
<!-- End TALLERES Section -->

 <!-- ======= GALERIA Section ======= -->
 <section  class="portfolio">
      <div class="container">

        <div class="section-title">
          <h2>Fotos de los talleres</h2>
        </div>

        <div class="row">
        @foreach($galeria_main as $gallery) 
        <div class="checkboxes" style=" width:530px;">
            <div class="doc-frame" style=" width:530px;">
              <input type="checkbox" name="rGroup" value="1" id="r{{$gallery['title']}}" checked="checked"/>
              <label class="checkbox-skin" for="r{{$gallery['title']}}" style=" width:530px;">
                <a href="{{$gallery['url']}}" target="_blank">
                <div class="doc-preview" style="background-image: url('{{$gallery['thumb']}} '); background-size: cover;background-position: center center; width:530px;">
                
                </div>
                </a>
              <label class="doc-name" style=" width:530px;"><i class="material-icons">photo</i>{{\Illuminate\Support\Str::limit($gallery['title'],50, $end='...')}}</label>
              </label>
            </div>
          </div>
          @endforeach 
        
        
          
        </div>
        
      

      </div>
    </section>
<!-- End GALERIA Section -->