import 'package:flutter/material.dart';

AppBar tasksAppBarWidget() => AppBar(
      actions: [
        ElevatedButton(
          onPressed: () {},
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(
                  const Color.fromARGB(255, 218, 183, 80)),
              foregroundColor: MaterialStateProperty.all(
                  const Color.fromARGB(255, 42, 6, 171)),
              padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 0, vertical: 0.5))),
          child: const Text("PRO"),
        ),
        IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz)),
      ],
    );
