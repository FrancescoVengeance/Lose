class User
{
  String username;
  String mail;
  String image = 'https://scontent.fblq1-1.fna.fbcdn.net/v/t1.6435-9/30716057_1523443434448950_8021549215731679232_n.jpg?_nc_cat=106&ccb=1-3&_nc_sid=09cbfe&_nc_ohc=zbIlF70B_HcAX_W93Ne&_nc_ht=scontent.fblq1-1.fna&oh=6553574893ee913c5745dcb4e128c5e3&oe=60B5D2DC';

  User({this.username, this.mail});
  User.copy(User user)
  {
    this.username = user.username;
    this.mail = user.mail;
    this.image = user.image;
  }
}