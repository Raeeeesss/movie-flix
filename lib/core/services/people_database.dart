class PersonModel {
  final String id;
  final String name;
  final String industry;
  final String role; // 'actor', 'actress', 'director'
  final String profileUrl;
  final List<String> knownMovies;

  const PersonModel({
    required this.id,
    required this.name,
    required this.industry,
    required this.role,
    required this.profileUrl,
    this.knownMovies = const [],
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return 'P';
  }
}

class PeopleDatabase {
  static final List<PersonModel> actors = [
    // ── MOLLYWOOD (MALAYALAM) ACTORS ─────────────────────────────────────────
    const PersonModel(
      id: 'm_act_1',
      name: 'Mohanlal',
      industry: 'Mollywood',
      role: 'actor',
      profileUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c4/Mohanlal_at_24th_Kerala_State_Film_Awards_crop.jpg/440px-Mohanlal_at_24th_Kerala_State_Film_Awards_crop.jpg',
      knownMovies: ['Lucifer', 'Drishyam', 'Neru', 'Pulimurugan', 'Oppam', 'Malaikottai Vaaliban', 'Spadikam', 'Manichitrathazhu', 'Vanaprastham', 'Bro Daddy', 'Devasuram', 'Rajavinte Makan', 'Chithram', 'Narasimham'],
    ),
    const PersonModel(
      id: 'm_act_2',
      name: 'Mammootty',
      industry: 'Mollywood',
      role: 'actor',
      profileUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1a/Mammootty_at_the_audio_launch_of_Pazhassi_Raja.jpg/440px-Mammootty_at_the_audio_launch_of_Pazhassi_Raja.jpg',
      knownMovies: ['Bramayugam', 'Kannur Squad', 'Bheeshma Parvam', 'Katha Innaleyum', 'Nanpakal Nerathu Mayakkam', 'Rorschach', 'Yatra', 'Kaathal', 'Turbo', 'CBI 5', 'Madhura Raja'],
    ),
    const PersonModel(
      id: 'm_act_3',
      name: 'Fahadh Faasil',
      industry: 'Mollywood',
      role: 'actor',
      profileUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Fahadh_Faasil.jpg/440px-Fahadh_Faasil.jpg',
      knownMovies: ['Aavesham', 'Joji', 'Kumbalangi Nights', 'Trance', 'Malik', 'Maheshinte Prathikaram', 'Njan Prakashan', 'Super Deluxe', 'Pushpa'],
    ),
    const PersonModel(
      id: 'm_act_4',
      name: 'Dulquer Salmaan',
      industry: 'Mollywood',
      role: 'actor',
      profileUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/9b/Dulquer_Salmaan_at_the_promotions_of_Chup.jpg/440px-Dulquer_Salmaan_at_the_promotions_of_Chup.jpg',
      knownMovies: ['Kurup', 'Charlie', 'Sita Ramam', 'King of Kotha', 'OK Kanmani', 'Mahanati', 'Ustad Hotel', 'Kammatipaadam', 'Lucky Baskhar'],
    ),
    const PersonModel(
      id: 'm_act_5',
      name: 'Prithviraj Sukumaran',
      industry: 'Mollywood',
      role: 'actor',
      profileUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Prithviraj_Sukumaran_at_Aadujeevitham_press_meet.jpg/440px-Prithviraj_Sukumaran_at_Aadujeevitham_press_meet.jpg',
      knownMovies: ['The Goat Life', 'Ayyappanum Koshiyum', 'Jana Gana Mana', 'Driving Licence', 'Kaduva', 'Lucifer', 'Indian Rupee', 'Koode', 'Salaar'],
    ),
    const PersonModel(
      id: 'm_act_6',
      name: 'Tovino Thomas',
      industry: 'Mollywood',
      role: 'actor',
      profileUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/ca/Tovino_Thomas_at_Minnal_Murali_promotions.jpg/440px-Tovino_Thomas_at_Minnal_Murali_promotions.jpg',
      knownMovies: ['Minnal Murali', '2018', 'Kala', 'Thallumaala', 'Forensic', 'Dear Friend', 'ARM', 'Identity', 'Lucifer'],
    ),
    const PersonModel(
      id: 'm_act_7',
      name: 'Asif Ali',
      industry: 'Mollywood',
      role: 'actor',
      profileUrl: 'https://images.unsplash.com/photo-1522075469751-3a6694fb2f61?auto=format&fit=crop&w=400&q=80',
      knownMovies: ['Kooman', 'Kishkindha Kaandam', 'Btech', 'Kettiyollaanu Ente Malakha', 'Kakshi Amminippilla', 'Thalavan'],
    ),
    const PersonModel(
      id: 'm_act_8',
      name: 'Nivin Pauly',
      industry: 'Mollywood',
      role: 'actor',
      profileUrl: 'https://images.unsplash.com/photo-1501196354995-cbb51c65aaea?auto=format&fit=crop&w=400&q=80',
      knownMovies: ['Premam', 'Moothon', 'Bangalore Days', 'Kayamkulam Kochunni', 'Jacobinte Swargarajyam', 'Malayankunju', 'Varshangalkku Shesham'],
    ),

    // ── KOLLYWOOD (TAMIL) ACTORS ─────────────────────────────────────────────
    const PersonModel(
      id: 'k_act_1',
      name: 'Vijay',
      industry: 'Kollywood',
      role: 'actor',
      profileUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/cd/Vijay_at_the_Leo_Success_Meet.jpg/440px-Vijay_at_the_Leo_Success_Meet.jpg',
      knownMovies: ['Leo', 'Master', 'Theri', 'Mersal', 'Varisu', 'Ghilli', 'Kaththi', 'GOAT'],
    ),
    const PersonModel(
      id: 'k_act_2',
      name: 'Rajinikanth',
      industry: 'Kollywood',
      role: 'actor',
      profileUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/60/Rajinikanth_in_2023.jpg/440px-Rajinikanth_in_2023.jpg',
      knownMovies: ['Jailer', 'Baasha', 'Enthiran', 'Kabali', 'Petta', 'Sivaji', 'Vettaiyan', 'Coolie'],
    ),
    const PersonModel(
      id: 'k_act_3',
      name: 'Kamal Haasan',
      industry: 'Kollywood',
      role: 'actor',
      profileUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d4/Kamal_Haasan.jpg/440px-Kamal_Haasan.jpg',
      knownMovies: ['Vikram', 'Nayakan', 'Indian', 'Dasavathaaram', 'Vishwaroopam', 'Hey Ram', 'Kalki 2898 AD'],
    ),
    const PersonModel(
      id: 'k_act_4',
      name: 'Suriya',
      industry: 'Kollywood',
      role: 'actor',
      profileUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c2/Suriya_at_Soorarai_Pottru_promotions.jpg/440px-Suriya_at_Soorarai_Pottru_promotions.jpg',
      knownMovies: ['Soorarai Pottru', 'Jai Bhim', 'Ghajini', 'Singam', 'Kaakha Kaakha', '24', 'Kanguva'],
    ),
    const PersonModel(
      id: 'k_act_5',
      name: 'Dhanush',
      industry: 'Kollywood',
      role: 'actor',
      profileUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e0/Dhanush_in_2022.jpg/440px-Dhanush_in_2022.jpg',
      knownMovies: ['Asuran', 'Karnan', 'Vada Chennai', 'VIP', 'Raanjhanaa', 'Captain Miller', 'Raayan'],
    ),

    // ── HOLLYWOOD ACTORS ──────────────────────────────────────────────────────
    const PersonModel(
      id: 'h_act_1',
      name: 'Robert Downey Jr.',
      industry: 'Hollywood',
      role: 'actor',
      profileUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a2/Robert_Downey_Jr%2C_2014_SDCC_Crop.jpg/440px-Robert_Downey_Jr%2C_2014_SDCC_Crop.jpg',
      knownMovies: ['Oppenheimer', 'Iron Man', 'The Avengers', 'Sherlock Holmes', 'Zodiac'],
    ),
    const PersonModel(
      id: 'h_act_2',
      name: 'Tom Cruise',
      industry: 'Hollywood',
      role: 'actor',
      profileUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/33/Tom_Cruise_by_Gage_Skidmore_2.jpg/440px-Tom_Cruise_by_Gage_Skidmore_2.jpg',
      knownMovies: ['Top Gun: Maverick', 'Mission: Impossible', 'Edge of Tomorrow', 'Minority Report'],
    ),
    const PersonModel(
      id: 'h_act_3',
      name: 'Cillian Murphy',
      industry: 'Hollywood',
      role: 'actor',
      profileUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Cillian_Murphy_Press_Conference_Oppenheimer.jpg/440px-Cillian_Murphy_Press_Conference_Oppenheimer.jpg',
      knownMovies: ['Oppenheimer', 'Peaky Blinders', 'Inception', 'Dunkirk', '28 Days Later'],
    ),
    const PersonModel(
      id: 'h_act_4',
      name: 'Leonardo DiCaprio',
      industry: 'Hollywood',
      role: 'actor',
      profileUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/25/Leonardo_DiCaprio_2014.jpg/440px-Leonardo_DiCaprio_2014.jpg',
      knownMovies: ['Inception', 'Titanic', 'The Wolf of Wall Street', 'The Revenant', 'Shutter Island', 'Killers of the Flower Moon'],
    ),

    // ── BOLLYWOOD ACTORS ──────────────────────────────────────────────────────
    const PersonModel(
      id: 'b_act_1',
      name: 'Shah Rukh Khan',
      industry: 'Bollywood',
      role: 'actor',
      profileUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6e/Shah_Rukh_Khan_graces_the_launch_of_the_new_HNS_merchandise.jpg/440px-Shah_Rukh_Khan_graces_the_launch_of_the_new_HNS_merchandise.jpg',
      knownMovies: ['Jawan', 'Pathaan', 'DDLJ', 'Swades', 'My Name Is Khan', 'Don', 'Dunki'],
    ),
    const PersonModel(
      id: 'b_act_2',
      name: 'Aamir Khan',
      industry: 'Bollywood',
      role: 'actor',
      profileUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d7/Aamir_Khan_at_PK_promotions.jpg/440px-Aamir_Khan_at_PK_promotions.jpg',
      knownMovies: ['Dangal', '3 Idiots', 'Taare Zameen Par', 'Lagaan', 'PK', 'Ghajini'],
    ),
  ];

  static final List<PersonModel> actresses = [
    // ── MOLLYWOOD (MALAYALAM) ACTRESSES ──────────────────────────────────────
    const PersonModel(
      id: 'm_actress_1',
      name: 'Sai Pallavi',
      industry: 'Mollywood',
      role: 'actress',
      profileUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/77/Sai_Pallavi_at_Gargi_promotions.jpg/440px-Sai_Pallavi_at_Gargi_promotions.jpg',
      knownMovies: ['Premam', 'Gargi', 'Fidaa', 'Love Story', 'Shyam Singha Roy', 'Amaran', 'Athiran'],
    ),
    const PersonModel(
      id: 'm_actress_2',
      name: 'Manju Warrier',
      industry: 'Mollywood',
      role: 'actress',
      profileUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/91/Manju_Warrier_cropped.jpg/440px-Manju_Warrier_cropped.jpg',
      knownMovies: ['Asuran', 'Lucifer', 'Kanmadham', 'How Old Are You', 'Thunivu', 'Prathi Poovankozhi', 'Vettaiyan'],
    ),
    const PersonModel(
      id: 'm_actress_3',
      name: 'Nazriya Nazim',
      industry: 'Mollywood',
      role: 'actress',
      profileUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/75/Nazriya_Nazim.jpg/440px-Nazriya_Nazim.jpg',
      knownMovies: ['Bangalore Days', 'Neram', 'Ohm Shanthi Oshaana', 'Trance', 'Ante Sundaraniki', 'Raja Rani'],
    ),
    const PersonModel(
      id: 'm_actress_4',
      name: 'Parvathy Thiruvothu',
      industry: 'Mollywood',
      role: 'actress',
      profileUrl: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=400&q=80',
      knownMovies: ['Take Off', 'Charlie', 'Ennu Ninte Moideen', 'Qarib Qarib Singlle', 'Thangalaan', 'Uyare'],
    ),

    // ── KOLLYWOOD (TAMIL) ACTRESSES ──────────────────────────────────────────
    const PersonModel(
      id: 'k_actress_1',
      name: 'Nayanthara',
      industry: 'Kollywood',
      role: 'actress',
      profileUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Nayanthara_at_Jawan_event.jpg/440px-Nayanthara_at_Jawan_event.jpg',
      knownMovies: ['Jawan', 'Raja Rani', 'Aramm', 'Netrikann', 'Viswasam', 'Naanum Rowdy Dhaan', 'Annapoorani'],
    ),
    const PersonModel(
      id: 'k_actress_2',
      name: 'Trisha Krishnan',
      industry: 'Kollywood',
      role: 'actress',
      profileUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d6/Trisha_at_Ponniyin_Selvan_event.jpg/440px-Trisha_at_Ponniyin_Selvan_event.jpg',
      knownMovies: ['Leo', 'Ponniyin Selvan', '96', 'Ghilli', 'Vinnaithaandi Varuvaayaa', 'GOAT'],
    ),
  ];

  static final List<PersonModel> directors = [
    // ── MOLLYWOOD (MALAYALAM) DIRECTORS ──────────────────────────────────────
    const PersonModel(
      id: 'm_dir_1',
      name: 'Lijo Jose Pellissery',
      industry: 'Mollywood',
      role: 'director',
      profileUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/87/Lijo_Jose_Pellissery.jpg/440px-Lijo_Jose_Pellissery.jpg',
      knownMovies: ['Malaikottai Vaaliban', 'Jallikattu', 'Churuli', 'Nanpakal Nerathu Mayakkam', 'Ee.Ma.Yau.', 'Angamaly Diaries', 'Amen'],
    ),
    const PersonModel(
      id: 'm_dir_2',
      name: 'Jeethu Joseph',
      industry: 'Mollywood',
      role: 'director',
      profileUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0a/Jeethu_Joseph.jpg/440px-Jeethu_Joseph.jpg',
      knownMovies: ['Drishyam', 'Drishyam 2', 'Neru', 'Memories', 'My Boss', '12th Man', 'Nunakuzhi'],
    ),
    const PersonModel(
      id: 'm_dir_3',
      name: 'Basil Joseph',
      industry: 'Mollywood',
      role: 'director',
      profileUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/43/Basil_Joseph.jpg/440px-Basil_Joseph.jpg',
      knownMovies: ['Minnal Murali', 'Godha', 'Kunjiramayanam'],
    ),

    // ── HOLLYWOOD DIRECTORS ───────────────────────────────────────────────────
    const PersonModel(
      id: 'h_dir_1',
      name: 'Christopher Nolan',
      industry: 'Hollywood',
      role: 'director',
      profileUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/9/95/Christopher_Nolan_Cannes_2018.jpg/440px-Christopher_Nolan_Cannes_2018.jpg',
      knownMovies: ['Oppenheimer', 'Interstellar', 'Inception', 'The Dark Knight', 'Dunkirk', 'Tenet'],
    ),
    const PersonModel(
      id: 'h_dir_2',
      name: 'Quentin Tarantino',
      industry: 'Hollywood',
      role: 'director',
      profileUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0b/Quentin_Tarantino_by_Gage_Skidmore.jpg/440px-Quentin_Tarantino_by_Gage_Skidmore.jpg',
      knownMovies: ['Pulp Fiction', 'Django Unchained', 'Inglourious Basterds', 'Kill Bill', 'Once Upon a Time in Hollywood'],
    ),
  ];

  static List<PersonModel> getPeopleForIndustries({
    required List<String> industries,
    required String role, // 'actor', 'actress', 'director'
    String searchQuery = '',
  }) {
    List<PersonModel> source;
    if (role == 'actor') {
      source = actors;
    } else if (role == 'actress') {
      source = actresses;
    } else {
      source = directors;
    }

    List<PersonModel> filtered = source;
    if (industries.isNotEmpty) {
      filtered = source.where((p) => industries.contains(p.industry)).toList();
    }

    if (filtered.isEmpty) {
      filtered = source;
    }

    if (searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase().trim();
      return filtered.where((p) => p.name.toLowerCase().contains(q)).toList();
    }

    return filtered;
  }
}
