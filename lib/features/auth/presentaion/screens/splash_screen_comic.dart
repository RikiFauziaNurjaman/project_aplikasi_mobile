import 'dart:async';

import 'package:flutter/material.dart';
import 'login_screen_comic.dart';

class SplashScreenComic extends StatefulWidget {
	const SplashScreenComic({Key? key}) : super(key: key);

	@override
	State<SplashScreenComic> createState() => _SplashScreenComicState();
}

class _SplashScreenComicState extends State<SplashScreenComic> {
	Timer? _timer;

	@override
	void initState() {
		super.initState();
		// 1 second duration
		_timer = Timer(const Duration(seconds: 20), _onTimerComplete);
	}

		void _onTimerComplete() {
			Navigator.of(context).pushReplacement(
				MaterialPageRoute(builder: (_) => const LoginScreen()),
			);
		}

	@override
	void dispose() {
		_timer?.cancel();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Colors.blue,
			body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
				children: [
					Row(
					  children: [
					    Center(
					    	child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
					    		children: [
					    			Image.asset(
					    				'images/auth/logo.png',
					    				width: 500,
					    				fit: BoxFit.fitHeight,
					    			),
					    			const Text(
					    				'COMICU',
					    				style: TextStyle(
					    					color: Colors.white,
					    					fontSize: 20,
					    					fontWeight: FontWeight.bold,
					    				),
					    			),
                    const Text("Platform Pembaca Komik Digital",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
					    		],
					    	),
					    ),
					  ],
					),
			  ],
			),
		);
	}
}
