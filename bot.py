#!/usr/bin/python3.7

# Packages used:
# https://github.com/theskumar/python-dotenv
# https://github.com/Rapptz/discord.py

# Documentation for Discord.py:
# https://discordpy.readthedocs.io/en/stable

import os
import discord
import logging
from dotenv import load_dotenv
from discord.ext import commands

logging.basicConfig(level=logging.INFO)

load_dotenv()
token = os.getenv('DISCORD_TOKEN')

bot = commands.Bot(command_prefix='>')


@bot.event
async def on_ready():
    await bot.change_presence(status=discord.Status.online, activity=discord.Game('powered by HelioHost'))


@bot.command()
async def hello(ctx):
    await ctx.send('General Kenobi.')


@bot.event
async def on_command_error(ctx, error):
    if isinstance(error, discord.ext.commands.MissingRequiredArgument):
        await ctx.send('An error occurred: {}'.format(error))


@bot.command()
async def status(ctx, arg):
    if arg == 'online':
        await bot.change_presence(status=discord.Status.online)
    elif arg == 'idle':
        await bot.change_presence(status=discord.Status.idle)
    elif arg == 'dnd' or arg == 'do_not_disturb':
        await bot.change_presence(status=discord.Status.do_not_disturb)
    else:
        await ctx.send('Argument not recognized: ' + arg)
        return
    await ctx.send('Changing status to {}.'.format(arg))


bot.run(token)
