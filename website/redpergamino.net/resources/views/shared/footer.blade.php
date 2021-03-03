<!-- ======= Footer ======= -->
<footer id="footer">
    <div class="footer-top">
      <div class="container">
        <div class="row">
          <div class="col-lg-3 col-md-5 footer-links">
            <ul>
              <li><i class="bx bx-chevron-right"></i> <a href="#">Sobre Pergamino</a></li>
              <li><i class="bx bx-chevron-right"></i> <a href="#">Sobre PROCAGICA</a></li>
              <li><i class="bx bx-chevron-right"></i> <a href="#">Organizaciones</a></li>
              <li><i class="bx bx-chevron-right"></i> <a href="#">Contacto técnico</a></li>
              <li><i class="bx bx-chevron-right"></i> <a href="#">Contacto Administrativo</a></li>
            </ul>
            
          </div>

          <div class="col-lg-5 col-md-7 footer-links">
          <h4 class="mb-2"> Herramientas Disponibles </h4> 
            <div class="row">
              <div class="col-lg-6 col-md-6 col-sm-12">
                <ul>
                  <li>
                    <i class="bx bx-chevron-right"></i>
                    <a href="/app-mapas" target="_blank">MAPALERTA</a>
                  </li>
                  <li>
                    <i class="bx bx-chevron-right"></i>
                    <a href="/app-optiroya" target="_blank" >OPTIROYA</a>
                  </li>
                  <li>
                    <i class="bx bx-chevron-right"></i>
                    <a href="/app-experoya" target="_blank">EXPEROYA</a>
                  </li>
                  <li>
                    <i class="bx bx-chevron-right"></i>
                    <a href="/app-stadman" target="_blank">STADMAN</a>
                  </li>
                </ul>
              </div>
              <div class="col-lg-6 col-md-6 col-sm-12">
                <ul>
                  <li>
                    <i class="bx bx-chevron-right"></i>
                    <a href="/app-stadinc" target="_blank">STADINC</a>
                  </li>
                  <li>
                    <i class="bx bx-chevron-right"></i>
                    <a href="/app-miroya" target="_blank">MIROYA</a>
                  </li>
                  <li>
                    <i class="bx bx-chevron-right"></i>
                    <a href="/app-seroya" target="_blank">SEROYA</a>
                  </li>
                  <li>
                    <i class="bx bx-chevron-right"></i>
                    <a href="/#" target="_blank">Aplicación Productor</a>
                  </li>
                </ul>
              </div>
              
            </div>
            <!-- <ul>
              <li class="text-light"> <h4> Herramientas Disponibles </h4> </li>
              <li>
                <i class="bx bx-chevron-right"></i>
                <a href="/app-mapas" target="_blank">MAPALERTA</a>
              </li>
              <li>
                <i class="bx bx-chevron-right"></i>
                <a href="/app-optiroya">OPTIROYA</a>
              </li>
              <li>
                <i class="bx bx-chevron-right"></i>
                <a href="/app-experoya">EXPEROYA</a>
              </li>
              <li>
                <i class="bx bx-chevron-right"></i>
                <a href="/app-stadman">STADMAN</a>
              </li>
              <li>
                <i class="bx bx-chevron-right"></i>
                <a href="/app-stadinc">STADINC</a>
              </li>
              <li>
                <i class="bx bx-chevron-right"></i>
                <a href="/app-miroya">MIROYA</a>
              </li>
              <li>
                <i class="bx bx-chevron-right"></i>
                <a href="/app-seroya">SEROYA</a>
              </li>
              <li>
                <i class="bx bx-chevron-right"></i>
                <a href="/#">Aplicación Productor</a>
              </li>
            </ul> -->
          </div>

          <!-- <div class="col-lg-2 col-md-6 footer-links">
            <ul>
              <li><i class="bx bx-chevron-right"></i> <a href="#">Herramientas Disponibles</a></li>
              <li><i class="bx bx-chevron-right"></i> <a href="#">Módulo Socio-económico</a></li>
              <li><i class="bx bx-chevron-right"></i> <a href="#">IPSIM</a></li>
              <li><i class="bx bx-chevron-right"></i> <a href="#">Mapa de Incidencia Regional</a></li>
              <li><i class="bx bx-chevron-right"></i> <a href="#">Módulo Agroclimático</a></li>
            </ul>
          </div> -->

          <!-- <div class="col-lg-4 col-md-6 footer-links">
            <h4></h4>
            <ul>
              <li><i class="bx bx-chevron-right"></i> <a href="#">Módulo Socio-económico</a></li>
              <li><i class="bx bx-chevron-right"></i> <a href="#">IPSIM</a></li>
              <li><i class="bx bx-chevron-right"></i> <a href="#">Mapa de Incidencia Regional</a></li>
              <li><i class="bx bx-chevron-right"></i> <a href="#">Módulo Agroclimático</a></li>
            </ul>
          </div> -->

          <div class="col-lg-4 col-md-6 footer-newsletter" style="color:#ffffff;">
            <h3>Contáctenos</h3>
            <form action="forms/contact.php" method="post" role="form" class="php-email-form">
                <div class="form-group">
                  <label for="name">Correo</label>
                  <input type="email" class="form-control" name="email" id="email" data-rule="email" data-msg="Please enter a valid email" />
                  <div class="validate"></div>
                </div>
              <div class="form-group">
                <label for="name">Asunto</label>
                <input type="text" class="form-control" name="subject" id="subject" data-rule="minlen:4" data-msg="Please enter at least 8 chars of subject" />
                <div class="validate"></div>
              </div>
              <div class="form-group">
                <label for="name">Mensajes</label>
                <textarea class="form-control" name="message" rows="5" data-rule="required" data-msg="Please write something for us"></textarea>
                <div class="validate"></div>
              </div>
              
              <div class="text-center"><button type="submit">Enviar</button></div>
            </form>
          </div>

        </div>
        <br>
        
    </div>
    <div class ="footer-white">

      <img src="{{URL::asset('img/header-image.png')}}" style="max-width: 50%;left:0px;" alt="">
      <img src="{{URL::asset('img/gpl.png')}}" style="max-width:8%; float: right; margin-right:50px; margin-top:10px;" alt=""></div>
  </footer><!-- End Footer -->

  <a href="#" class="back-to-top"><i class="bx bxs-up-arrow-alt"></i></a>

  <!-- Vendor JS Files -->
  <script src="{{URL::asset('vendor/jquery/jquery.min.js')}}"></script>
  <script src="{{URL::asset('vendor/bootstrap/js/bootstrap.bundle.min.js')}}"></script>
  <script src="{{URL::asset('vendor/jquery.easing/jquery.easing.min.js')}}"></script>
  <script src="{{URL::asset('vendor/php-email-form/validate.js')}}"></script>
  <script src="{{URL::asset('vendor/isotope-layout/isotope.pkgd.min.js')}}"></script>
  <script src="{{URL::asset('vendor/venobox/venobox.min.js')}}"></script>
  <script src="{{URL::asset('vendor/owl.carousel/owl.carousel.min.js')}}"></script>
  <script src="{{URL::asset('vendor/aos/aos.js')}}"></script>
 
  <script src="https://s3-us-west-2.amazonaws.com/s.cdpn.io/8877/jquery.flexslider.js" type="text/javascript"></script>
  <script src="{{URL::asset('js/hero/main.js')}}"></script>
  <!-- Template Main JS File -->
  <script src="{{URL::asset('js/main.js')}}"></script>

</body>

</html>