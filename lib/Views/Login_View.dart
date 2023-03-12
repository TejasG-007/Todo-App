import 'package:todo/Constant/ImportFile.dart';

class LoginView extends StatefulWidget{
  const LoginView({super.key});

  @override
  State createState()=>_LoginViewState();
}

Authentication _auth = Authentication();

class _LoginViewState extends State{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: whiteColor,
      body: Column(
        children: [
          const SizedBox(height: 10,),
          Image.asset("assets/signin.jpg"),
          Container(
            margin: const EdgeInsets.all(10),
            child: Text("TODO App",style: GoogleFonts.montserrat(
              color: homePageGreyTextColor,fontWeight: FontWeight.bold,fontSize: 40,
            ),),
          ),
          const Spacer(),
          Container(
            margin: const EdgeInsets.all(40),
            child: Text("WELCOME",style: GoogleFonts.montserrat(
              color: homePageGreyTextColor,fontWeight: FontWeight.bold,fontSize: 20,
            ),),
          ),
          Consumer<StateHelper>(
            builder:(context,model,child)=> InkWell(
              onTap: (){
                _auth.signInWithGoogle();
              },borderRadius: BorderRadius.circular(10),
              child: Container(
                width: MediaQuery.of(context).size.width*.9,
                height: 50,
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                          blurRadius: 8,
                          offset: Offset(.9,.9),
                          color: Colors.grey
                      )]
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset("assets/google.png",scale: 15,),
                    Text("SIGN-IN with GOOGLE",style: GoogleFonts.montserrat(
                      color: homePageGreyTextColor,fontWeight: FontWeight.bold,fontSize: 20,
                    ))
                  ],
                ),
              ),
            ),
          ),
          const Spacer()

        ],
      ),
    );
  }
}