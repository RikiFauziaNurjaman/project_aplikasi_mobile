import 'package:project_aplikasi_mobile/data/chapter_comic.dart';

import '../models/list_comic.dart';

var listComic = [
  Comic(
    id: '1',
    title: 'One Piece',
    author: 'Eiichiro Oda',
    coverUrl: 'images/cover/onepiece.jpg',
    description:
        'Tepat sebelum ajalnya, "Sang Raja Bajak Laut Legendaris", Gold Roger, mengumumkan bahwa dia telah menyembunyikan harta karunnya di sebuah tempat di dunia ini... Kata-katanya tersebut telah membawa dunia menuju zaman kejayaan bajak laut! Dan kini, seorang pemuda bernama Luffy, telah memulai perjalanannya untuk menemukan harta karun tersebut, dan menjadi sang raja bajak laut!',
    rating: 4.3,
    viewCount: '2,222k views',
    tags: ['Action', 'Adventure', 'Fantasy'],
    chapters: onePieceChapters,
    latestChapter: 'Chapter 1050',
  ),

  Comic(
    id: '2',
    title: 'Solo Leveling',
    author: 'Chugong',
    coverUrl: 'images/cover/sololaveling.jpg',
    description:
        'Sebuah gerbang misterius menghubungkan dunia nyata dengan dunia monster...',
    rating: 4.5,
    viewCount: '3,120k views',
    tags: ['Action', 'Fantasy', 'Webtoon'],
    chapters: [],
    latestChapter: 'Chapter 179',
  ),

  Comic(
    id: '3',
    title: 'Naruto',
    author: 'Masashi Kisimoto',
    coverUrl: 'images/cover/naruto.jpg',
    description:
        'Seorang ninja muda yang bercita-cita menjadi pemimpin desanya.',
    rating: 4.2,
    viewCount: '1,980k views',
    tags: ['Action', 'Adventure', 'Ninja'],
    chapters: [],
    latestChapter: 'Chapter 700',
  ),

  Comic(
    id: '4',
    title: 'Doraemon',
    author: 'Fujiko F. Fujio',
    coverUrl: 'images/cover/doraemon.jpg',
    description:
        'Kisah robot kucing dari abad 22 yang membantu seorang anak laki-laki.',
    rating: 4.0,
    viewCount: '800k views',
    tags: ['Comedy', 'Sci-Fi', 'Kids'],
    chapters: [],
    latestChapter: 'Chapter 2000',
  ),

  Comic(
    id: '5',
    title: 'The God of High School',
    author: 'Yongje Park',
    coverUrl: 'images/cover/godofhighschool.jpg',
    description:
        'Turnamen bela diri antar siswa SMA untuk menentukan siapa yang terkuat.',
    rating: 4.1,
    viewCount: '1,100k views',
    tags: ['Action', 'Martial Arts', 'Webtoon'],
    chapters: [],
    latestChapter: 'Chapter 179',
  ),

  Comic(
    id: '6',
    title: 'One Punch Man',
    author: 'ONE',
    coverUrl: 'images/cover/onepuchman.jpeg',
    description:
        'Kisah pahlawan yang bisa mengalahkan musuh hanya dengan satu pukulan.',
    rating: 4.4,
    viewCount: '2,500k views',
    tags: ['Action', 'Comedy', 'Superhero'],
    chapters: [],
    latestChapter: 'Chapter 160',
  ),

  Comic(
    id: '7',
    title: 'Black Clover',
    author: 'Yuki Tabata',
    coverUrl: 'images/cover/backclover.jpeg',
    description:
        'Di dunia tempat sihir adalah segalanya, Asta terlahir sebagai yatim piatu yang miskin dan tidak bisa menggunakan sihir. Ia bercita-cita menjadi "Kaisar Sihir", posisi untuk penyihir terkuat, demi membuktikan kemampuannya dan menepati janji dengan seorang teman! Perjuangan seorang pemuda dalam meraih cita-cita, menjadi hidup lewat gambar yang menawan di kisah fantasi sihir ini!.',
    rating: 4.3,
    viewCount: '1,500k views',
    tags: ['Action', 'Comedy', 'Superhero'],
    chapters: [],
    latestChapter: 'Chapter 340',
  ),

  Comic(
    id: '8',
    title: 'Boruto: Naruto Next Generations',
    author: 'MASASHI KISHIMOTO / MIKIO IKEMOTO',
    coverUrl: 'images/cover/boruto.jpeg',
    description:
        'Sesuatu telah mengubah "memori" para warga. Boruto yang kini menjadi buron melarikan diri dari Konoha bersama Sasuke. Di tengah konflik itu, yang telah menanti keduanya adalah...',
    rating: 4.5,
    viewCount: '4,500k views',
    tags: ['Action', 'Comedy', 'Superhero'],
    chapters: [],
    latestChapter: 'Chapter 90',
  ),

  Comic(
    id: '9',
    title: 'Jujutsu Kaisen',
    author: 'Gege Akutami',
    coverUrl: 'images/cover/jujutsukaijen.jpg',
    description:
        'Yuuji Itadori adalah salah seorang anggota Klub Peneliti Hal Gaib di sekolahnya yang cekatan serta memiliki fisik yang tangguh. Pada suatu hari, segel "Benda Terkutuk" yang tersimpan di sekolahnya terlepas, dan mengundang para monster yang disebut "Makhluk Kutukan" di sana! Akan tetapi, pertemuannya dengan pemuda bernama Megumi Fushiguro yang ditugaskan untuk mencari "Benda Terkutuk" itu, mengantarkannya dalam masalah yang lebih rumit lagi!.',
    rating: 4.5,
    viewCount: '4,500k views',
    tags: ['Action', 'Comedy', 'Superhero'],
    chapters: [],
    latestChapter: 'Chapter 200',
  ),

  Comic(
    id: '10',
    title: 'SAKAMOTO DAYS',
    author: 'YUTO SUZUKI',
    coverUrl: 'images/cover/sakamoto.jpg',
    description:
        'Konon hiduplah seorang pembunuh bayaran terkuat bernama Taro Sakamoto. Dia ditakuti oleh para penjahat dan dikagumi oleh para pembunuh bayaran… Namun pada suatu hari, dia jatuh cinta pada seorang wanita!!! Sakamoto pun memilih untuk pensiun, menikah, dan mempunyai anak. Bahkan perut Sakamoto pun sampai membuncit! Siapa sangka sosok asli pria gempal pemilik toko kelontong itu adalah pembunuh bayaran legendaris?! Sebagai seorang ayah, dia berupaya melindungi keluarga dan juga keseharian mereka!.',
    rating: 4.5,
    viewCount: '4,500k views',
    tags: ['Action', 'Comedy', 'Superhero'],
    chapters: [],
    latestChapter: 'Chapter 100',
  ),
];
