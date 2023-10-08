<?php

namespace Api;

use PHPUnit\Framework\TestCase;

final class UserTest extends TestCase
{
    public function testClassConstructor() {
    	$user = new User(18, 'John');

    	$this->assertSame('John', $user->name);
    	$this->assertSame(18, $user->age);
    	$this->assertEmpty($user->favorite_movies);
    }

    public function testAddFavoriteMovie() {
    	$user = new User(18, 'John');

    	$this->assertTrue($user->addFavoriteMovie('Avengers'));
    	$this->assertContains('Avengers', $user->favorite_movies);
    	$this->assertCount(1, $user->favorite_movies);
    }
}
